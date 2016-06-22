import Darwin

extension String {
	init?(contentsOfFileAtPath filePath: String) {
		var fileContents = ""
		let fp = fopen(filePath, "r")
		defer { fclose(fp) }

		if fp != nil {
			var buffer = [CChar](count: 1024, repeatedValue: CChar(0))
			while fgets(&buffer, Int32(1024), fp) != nil {
				fileContents = fileContents + String.fromCString(buffer)!
			}
			self.init(fileContents)
		} else {
			return nil
		}
	}
}

extension UnicodeScalar: StringLiteralConvertible {
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
