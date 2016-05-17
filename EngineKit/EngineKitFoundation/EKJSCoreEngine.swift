import JavaScriptCore

extension NSObject: Scriptable {}

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
	var errorWasTriggered = false

	public init() {
		context.exceptionHandler = { context, value in
			let stackTrace = value["stack"].toString()
			let lineNumber = value["line"].toInt32()
			let column = value["column"].toInt32()

			print("JAVASCRIPT ERROR: \(value) in method \(stackTrace)\n"
				+ "Line number \(lineNumber), column \(column)")

			self.errorWasTriggered = true
		}

		let printFunc = { (value: JSValue) in
			print(value)
		} as @convention(block) (JSValue)->()
		let printObj = unsafeBitCast(printFunc, AnyObject.self)

		context["print"] = printObj
		context["alert"] = printObj
		context["console"] = Console()
	}

	public func addClass<T: Scriptable>(class: T.Type,
	                     withName className: String?,
	                              constructor: (() -> (T))? ) {
		let fullClassName = T.description().componentsSeparatedByString(".")
		let className = className ?? fullClassName.last!.toEKPrefixClassName()

		let constructorClosure: (@convention(block) () -> (NSObject))?

		if let constructor = constructor {
			constructorClosure = {
				// Attention! JavaScriptCore only supports NSObject subclasses
				return constructor() as! NSObject
				} as @convention(block) () -> (NSObject)
		} else {
			constructorClosure = {
				// Attention! JavaScriptCore only supports NSObject subclasses
				return T() as! NSObject
				} as @convention(block) () -> (NSObject)
		}

		let constructorObject = unsafeBitCast(constructorClosure,
		                                      AnyObject.self)

		context[className] = constructorObject
	}

	public func runScript(filename filename: String) throws {
		let fileManager = OSFactory.createFileManager()
		let scriptContents = fileManager.getContentsFromFile(filename)
		context.evaluateScript(scriptContents)

		if errorWasTriggered {
			throw EKError.ScriptEvaluationError
		}
	}

}
