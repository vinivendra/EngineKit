public protocol EKLanguageEngine {
	weak var engine: EKEngine? { get }

	init(engine: EKEngine)

	func addClass<T: EKLanguageCompatible>(_ class: T.Type,
	              withName className: String,
	              constructor: @escaping(() -> (T)) )
	func addObject<T: EKLanguageCompatible>(_ object: T,
	               withName name: String) throws
}

extension EKLanguageEngine {
	public func addClass<T: EKLanguageCompatible>
		(_ class: T.Type,
		 withName className: String)
		where T: Initable {

		addClass(T.self, withName: className, constructor: T.init)
	}
}

extension String {
	func toEKPrefixClassName() -> String {
		guard !self.ekHasPrefix("EK") else { return self }

		let uppercase = self.uppercased().utf8.dropFirst()
		let normal = self.utf8.dropFirst()
		var copy = self.utf8

		for (upper, char) in zip(uppercase, normal) {
			if upper == char {
				copy = copy.dropFirst()
			} else {
				break
			}
		}

		let result = "EK" + String(describing: copy)
		return result
	}
}
