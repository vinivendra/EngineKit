extension UnicodeScalar: ExpressibleByStringLiteral {
	public init(stringLiteral value: StringLiteralType) {
		self.init(value.unicodeScalars.first!)
	}

	public init(extendedGraphemeClusterLiteral value: String) {
		self.init(value.unicodeScalars.first!)
	}

	init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
		self.init(value)
	}
}
