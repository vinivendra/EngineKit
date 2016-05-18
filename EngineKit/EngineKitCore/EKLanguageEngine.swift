public protocol EKLanguageEngine {
	weak var engine: EKEngine? { get }

	init(engine: EKEngine)

	func runScript(filename filename: String) throws
	func addClass<T: Scriptable>(class: T.Type,
	              withName className: String,
	                       constructor: (() -> (T)) )
}

extension EKLanguageEngine {
	public func addClass<T: Scriptable where T: Initable>(class: T.Type,
	                     withName className: String) {
		addClass(T.self, withName: className, constructor: T.init)
	}
}

extension String {
	func toEKPrefixClassName() -> String {
		guard !self.hasPrefix("EK") else { return self }

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

		let result = "EK" + String(copy)
		return result
	}
}
