public protocol EKLanguageEngine {
	func runScript(filename filename: String) throws
	func addClass<T: Scriptable>(class: T.Type,
	              withName className: String?,
	              constructor: (() -> (T))? )
}

extension EKLanguageEngine {
	public func addClass<T: Scriptable>(class: T.Type) {
		addClass(T.self, withName: nil)
	}

	public func addClass<T: Scriptable>(class: T.Type, withName className: String?) {
		addClass(T.self, withName: className, constructor: nil)
	}
}

public protocol Scriptable {
	init()
	static func description() -> String
}

extension String {
	func toEKPrefixClassName() -> String {
		let uppercase = self.uppercaseString.utf8.dropFirst()
		let normal = self.utf8.dropFirst()
		var copy = self.utf8

		for (upper, char) in zip(uppercase, normal) {
			if upper == char {
				copy = copy.dropFirst()
			} else {
				break
			}
		}

		return "EK" + String(copy)
	}
}
