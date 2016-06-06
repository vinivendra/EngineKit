import JavaScriptCore

let languageFactory = EKJSCoreFactory()

// MARK: Console class
@objc protocol ConsoleExport: JSExport {
	func log(string: String)
}
class Console: NSObject, ConsoleExport {
	func log(string: String) {
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
	case Running
	case Callback
}

public class EKJSCoreEngine: EKLanguageEngine {
	let context = JSContext()
	var evaluationError: ErrorType?

	var state: EKJSCoreState = .Callback

	weak public var engine: EKEngine?

	public required init(engine: EKEngine) {
		self.engine = engine

		context.exceptionHandler = {[unowned self] context, value in
			let stackTrace = value["stack"].toString()
			let lineNumber = value["line"].toInt32()
			let column = value["column"].toInt32()

			self.fail("JAVASCRIPT ERROR: \(value) in method \(stackTrace)\n"
				+ "Line number \(lineNumber), column \(column)")
		}

		let printFunc = { (value: JSValue) in
			print(value)
			} as @convention(block) (JSValue)->()
		let printObj = unsafeBitCast(printFunc, AnyObject.self)
		context["print"] = printObj
		context["alert"] = printObj
		context["console"] = Console()

		let eventFunc = {[unowned self] (callback: JSValue, event: JSValue) in

			do {
				try engine.register(forEventNamed: event.toString()) {
					event in
					do {
						let object = try event.toNSObject()
						callback.callWithArguments([object])
					} catch EKError.ScriptConversionError(message:
						let message) {
							self.fail(message)
					} catch {
						self.fail()
					}
				}
			} catch EKError.EventRegistryError(message: let message) {
				self.fail(message)
			} catch {
				self.fail()
			}

			} as @convention(block) (JSValue, JSValue)->()
		let eventObj = unsafeBitCast(eventFunc, AnyObject.self)
		context["addCallbackForEvent"] = eventObj

		//
		var constructorClosure3: (@convention(block)
		(NSNumber, NSNumber, NSNumber) -> (NSObject))?

		constructorClosure3 = {
			(x: NSNumber,
			y: NSNumber,
			z: NSNumber) -> NSObject in

			return EKVector3(x: x.doubleValue,
			                 y: y.doubleValue,
			                 z: z.doubleValue)

			} as (@convention(block)
				(NSNumber, NSNumber, NSNumber) -> (NSObject))?

		let constructorObject3 = unsafeBitCast(constructorClosure3,
		                                      AnyObject.self)

		context["EKVector3"] = constructorObject3

		//
		var constructorClosure4: (@convention(block)
			(NSNumber, NSNumber, NSNumber, NSNumber) -> (NSObject))?

		constructorClosure4 = {
			(x: NSNumber,
			y: NSNumber,
			z: NSNumber,
			w: NSNumber) -> NSObject in

			return EKVector4(x: x.doubleValue,
			                 y: y.doubleValue,
			                 z: z.doubleValue,
			                 w: w.doubleValue)

			} as (@convention(block)
				(NSNumber, NSNumber, NSNumber, NSNumber) -> (NSObject))?

		let constructorObject4 = unsafeBitCast(constructorClosure4,
		                                      AnyObject.self)

		context["EKVector4"] = constructorObject4
	}

	public func addClass<T: Scriptable>(class: T.Type,
	                     withName className: String,
	                              constructor: (() -> (T)) ) {
		var constructorClosure: (@convention(block) () -> (NSObject))?

		constructorClosure = {[unowned self] in
			do {
				return try constructor().toNSObject()
			} catch EKError.ScriptConversionError(message:
				let message) {
					self.fail(message)
					return NSObject() // never reached
			} catch {
				self.fail()
				return NSObject() // never reached
			}
			} as @convention(block) () -> (NSObject)

		let constructorObject = unsafeBitCast(constructorClosure,
		                                      AnyObject.self)

		context[className] = constructorObject
	}

	public func addObject<T: Scriptable>(object: T,
	                      withName name: String) throws {
		do {
			try context[name] = object.toNSObject()
		} catch let error {
			throw error
		}
	}

	public func runScript(filename filename: String) throws {
		state = .Running

		let fileManager = OSFactory.createFileManager()
		let scriptContents = fileManager.getContentsFromFile(filename)
		context.evaluateScript(scriptContents)

		if let error = evaluationError {
			defer {
				evaluationError = nil
			}
			throw error
		}

		state = .Callback
	}

	func fail(message: String = "") {
		switch state {
		case .Callback:
			assertionFailure(message)
		case .Running:
			evaluationError = EKError.ScriptEvaluationError(message: message)
		}
	}
}

public class EKJSCoreFactory: EKLanguageFactory {
	public func createEKVector3(x x: Double,
	                              y: Double,
	                              z: Double) -> EKVector3 {
		return EKVector3(x: x, y: y, z: z)
	}

	public func createEKVector4(x x: Double,
	                              y: Double,
	                              z: Double,
	                              w: Double) -> EKVector4 {
		return EKVector4(x: x, y: y, z: z, w: w)
	}
}
