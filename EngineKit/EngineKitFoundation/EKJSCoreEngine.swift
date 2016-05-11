import JavaScriptCore

@objc protocol ConsoleExport: JSExport {
	func log(string: String)
}

class Console: NSObject {
}

extension Console: ConsoleExport {
	func log(string: String) {
		print(string)
	}
}

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

public class EKJSCoreEngine: EKLanguageEngine {
	let context = JSContext()

	public init() {
		context.exceptionHandler = { context, value in
			let stackTrace = value["stack"].toString()
			let lineNumber = value["line"].toInt32()
			let column = value["column"].toInt32()
			let moreInfo = "in method \(stackTrace)\nLine number \(lineNumber), column \(column)"
			print("JAVASCRIPT ERROR: \(value) \(moreInfo)")
		}

		let printFunc = { (value: JSValue) in
			print(value)
		} as @convention(block) (JSValue)->()
		let printObj = unsafeBitCast(printFunc, AnyObject.self)

		context["print"] = printObj
		context["alert"] = printObj

		context["console"] = Console()
	}

	public func runScript(filename filename: String) {
		let fileManager = OSFactory.createFileManager()
		let scriptContents = fileManager.getContentsFromFile(filename)
		context.evaluateScript(scriptContents)
	}

}
