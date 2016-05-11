import JavaScriptCore

extension NSObject: Scriptable {}

// MARK: Console class
@objc protocol ConsoleExport: JSExport {
	func log(string: String)
}
class Console: NSObject {
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

	public func addClass<T: Scriptable>(class: T.Type) {
		let className = T.description().componentsSeparatedByString(".").last!

		let constructorClosure = {
			// Attention! JavaScriptCore only supports NSObject subclasses
			return T() as! NSObject // swiftlint:disable:this force_cast
			} as @convention(block) () -> (NSObject)
		let constructorObject = unsafeBitCast(constructorClosure, AnyObject.self)

		context[className] = constructorObject
	}

	public func runScript(filename filename: String) {
		let fileManager = OSFactory.createFileManager()
		let scriptContents = fileManager.getContentsFromFile(filename)
		context.evaluateScript(scriptContents)
	}

}
