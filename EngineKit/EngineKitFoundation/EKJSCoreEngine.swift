import JavaScriptCore

@objc protocol ConsoleExport: JSExport {
	func log(string: String)
}

class Console: NSObject, ConsoleExport {
	func log(string: String) {
		print(string)
	}
}

public class EKJSCoreEngine: EKLanguageEngine {
	let context = JSContext()

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
		context.setObject(printObj, forKeyedSubscript: "alert")

		context.setObject(Console(), forKeyedSubscript: "console")
	}

	public func runScript(filename filename: String) {
		let fileManager = OSFactory.createFileManager()
		let scriptContents = fileManager.getContentsFromFile(filename)
		context.evaluateScript(scriptContents)
	}

}
