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
	var evaluationError: EKError?

	weak public var engine: EKEngine?

	public required init(engine: EKEngine) {
		self.engine = engine

		context.exceptionHandler = {[unowned self] context, value in
			let stackTrace = value["stack"].toString()
			let lineNumber = value["line"].toInt32()
			let column = value["column"].toInt32()

			print("JAVASCRIPT ERROR: \(value) in method \(stackTrace)\n"
				+ "Line number \(lineNumber), column \(column)")

			self.evaluationError = EKError.ScriptEvaluationError
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
					if let tap = $0 as? EKEventTap {
						callback.callWithArguments([tap])
					}
				}
			} catch EKError.EventRegistryError(message: let message) {
				let error = EKError.EventRegistryError(message: message)
				self.evaluationError = error
			} catch {
				self.evaluationError = EKError.ScriptEvaluationError
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
			} catch let error {
				if let error = error as? EKError {
					self.evaluationError = error
				} else {
					let message = "Error converting \(self.dynamicType) " +
						"\(self) into an NSObject."
					self.evaluationError = .ScriptConversionError(
						message: message)
				}

				return NSObject()
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

}
