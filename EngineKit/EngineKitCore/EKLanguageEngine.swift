public protocol EKLanguageEngine {
	func runScript(filename filename: String) throws
	func addClass<T: Scriptable>(class: T.Type)
}

public protocol Scriptable {
	init()
	static func description() -> String
}
