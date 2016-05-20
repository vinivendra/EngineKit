import JavaScriptCore

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
public class EKJSCoreEngine: EKLanguageEngine {
	let context = JSContext()
	var evaluationError: ErrorType?

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
			print("Adding callback \(callback) for event \(event)")

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

	public func runScript(filename filename: String) throws {
		let fileManager = OSFactory.createFileManager()
		let scriptContents = fileManager.getContentsFromFile(filename)
		context.evaluateScript(scriptContents)

		if let error = evaluationError {
			defer {
				evaluationError = nil
			}
			throw error
		}
	}

	func fail(message: String = "") {
		assertionFailure(message)
	}
}
