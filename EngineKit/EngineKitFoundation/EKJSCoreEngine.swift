import JavaScriptCore

public class EKJSCoreEngine: EKLanguageEngine {
	public let context = JSContext()

	public init() {
		context.exceptionHandler = { context, value in
			let stackTrace = value.objectForKeyedSubscript("stack").toString()
			let lineNumber = value.objectForKeyedSubscript("line").toInt32()
			let column = value.objectForKeyedSubscript("column").toInt32()
			let moreInfo = "in method \(stackTrace)\nLine number \(lineNumber), column \(column)"
			print("JAVASCRIPT ERROR: \(value) \(moreInfo)")
		}

		let printFunc = { (value: JSValue) in
			print(value)
		} as @convention(block) (JSValue)->()
		let printObj = unsafeBitCast(printFunc, AnyObject.self)

		context.setObject(printObj, forKeyedSubscript: "print")
	}
}
