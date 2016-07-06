import JavaScriptCore

// MARK: Console class
@objc protocol ConsoleExport: JSExport {
	func log(_ string: String)
}
class Console: NSObject, ConsoleExport {
	func log(_ string: String) {
		print(string)
	}
}

// MARK: JS Extensions
extension JSValue {
	@nonobjc subscript(name: String) -> AnyObject {
		get { return self.objectForKeyedSubscript(name) }
		set(newValue) { self.setObject(newValue, forKeyedSubscript: name) }
	}
}

extension JSContext {
	@nonobjc subscript(name: String) -> AnyObject {
		get { return self.objectForKeyedSubscript(name) }
		set(newValue) { self.setObject(newValue, forKeyedSubscript: name) }
	}
}

// MARK: EKJSCoreEngine
enum EKJSCoreState {
	case running
	case callback
}

public class EKJSCoreEngine: EKLanguageEngine {
	let context = JSContext()!
	var evaluationError: ErrorProtocol?

	var state: EKJSCoreState = .callback

	weak public var engine: EKEngine?

	public required init(engine: EKEngine) {
		self.engine = engine

		context.exceptionHandler = {[unowned self] context, value in
			let stackTrace = value?["stack"].toString()
			let lineNumber = value?["line"].toInt32()
			let column = value?["column"].toInt32()

			self.fail("JAVASCRIPT ERROR: \(value) in method \(stackTrace)\n"
				+ "Line number \(lineNumber), column \(column)")
		}

		let printFunc = { (value: JSValue) in
			print(value)
			} as @convention(block) (JSValue)->()
		let printObj = unsafeBitCast(printFunc, to: AnyObject.self)
		context["print"] = printObj
		context["alert"] = printObj
		context["console"] = Console()

		let eventFunc = {[unowned self] (callback: JSValue, event: JSValue) in
			do {
				try engine.register(forEventNamed: event.toString()) {
					event in
					do {
						let object = try event.toNSObject()
						callback.call(withArguments: [object])
					} catch EKError.scriptConversionError(message:
						let message) {
							self.fail(message)
					} catch {
						self.fail()
					}
				}
			} catch EKError.eventRegistryError(message: let message) {
				self.fail(message)
			} catch {
				self.fail()
			}

			} as @convention(block) (JSValue, JSValue)->()
		let eventObj = unsafeBitCast(eventFunc, to: AnyObject.self)
		context["addCallbackForEvent"] = eventObj

		addDataClasses()
	}

	func addDataClasses() {
		context["EKVector2"] = unsafeBitCast({
			(x: NSNumber, y: NSNumber) -> NSObject in
			return EKVector2(x: x.doubleValue,
				y: y.doubleValue)
			} as (@convention(block)
				(NSNumber, NSNumber) -> (NSObject))?, to: AnyObject.self)

		context["EKVector3"] = unsafeBitCast({
			(x: NSNumber, y: NSNumber, z: NSNumber) -> NSObject in
			return EKVector3(x: x.doubleValue,
				y: y.doubleValue,
				z: z.doubleValue)
			} as (@convention(block)
				(NSNumber, NSNumber, NSNumber) -> (NSObject))?, to: AnyObject.self)

		context["EKVector4"] = unsafeBitCast({
			(x: NSNumber, y: NSNumber, z: NSNumber, w: NSNumber) -> NSObject in
			return EKVector4(x: x.doubleValue,
				y: y.doubleValue,
				z: z.doubleValue,
				w: w.doubleValue)
			} as (@convention(block)
				(NSNumber, NSNumber, NSNumber, NSNumber) -> (NSObject))?,
		                                     to: AnyObject.self)
	}

	public func addClass<T: EKLanguageCompatible>(_ class: T.Type,
	                     withName className: String,
	                              constructor: (() -> (T)) ) {
		var constructorClosure: (@convention(block) () -> (NSObject))?

		constructorClosure = {[unowned self] in
			do {
				return try constructor().toNSObject()
			} catch EKError.scriptConversionError(message:
				let message) {
					self.fail(message)
					return NSObject() // never reached
			} catch {
				self.fail()
				return NSObject() // never reached
			}
			} as @convention(block) () -> (NSObject)

		let constructorObject = unsafeBitCast(constructorClosure,
		                                      to: AnyObject.self)

		context[className] = constructorObject
	}

	public func addObject<T: EKLanguageCompatible>(_ object: T,
	                      withName name: String) throws {
		do {
			try context[name] = object.toNSObject()
		} catch let error {
			throw error
		}
	}

	public func runScript(filename: String) throws {
		state = .running

		let fileManager = OSFactory.createFileManager()
		let scriptContents = fileManager.getContentsFromFile(filename)
		_ = context.evaluateScript(scriptContents)

		if let error = evaluationError {
			defer {
				evaluationError = nil
			}
			throw error
		}

		state = .callback
	}

	func fail(_ message: String = "") {
		switch state {
		case .callback:
			assertionFailure(message)
		case .running:
			evaluationError = EKError.scriptEvaluationError(message: message)
		}
	}
}
