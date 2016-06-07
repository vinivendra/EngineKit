extension Array where Element: IntegerLiteralConvertible {
	subscript(one index: Int) -> Element {
		get {
			if count > index {
				return self[index]
			} else {
				return 1
			}
		}
		set(newValue) {
			while count <= index {
				self.append(1)
			}
			self[index] = newValue
		}
	}

	subscript(zero index: Int) -> Element {
		get {
			if count > index {
				return self[index]
			} else {
				return 0
			}
		}
		set(newValue) {
			while count <= index {
				self.append(0)
			}
			self[index] = newValue
		}
	}
}

extension Dictionary where Value: IntegerLiteralConvertible {
	subscript(one index: Key) -> Value {
		get {
			return self[index] ?? 1
		}
	}

	subscript(zero index: Key) -> Value {
		get {
			return self[index] ?? 0
		}
	}

	subscript(one indexes: [Key]) -> Value {
		get {
			for index in indexes {
				if let result = self[index] {
					return result
				}
			}
			return 1
		}
	}

	subscript(zero indexes: [Key]) -> Value {
		get {
			for index in indexes {
				if let result = self[index] {
					return result
				}
			}
			return 0
		}
	}

	func zero(index: Key) -> Value {
		return self[index] ?? 0
	}
}

extension UnicodeScalar {
	var capitalized: UnicodeScalar {
		get {
			switch value {
			case 97...122:
				return UnicodeScalar(value - 32)
			default:
				return self
			}
		}
	}

	var isLetter: Bool {
		get {
			switch value {
			case 97...122, 65...90:
				return true
			default:
				return false
			}
		}
	}
}

extension String {
	var capitalizedString: String {
		get {
			var result = ""
			var shouldCapitalizeNextChar = true

			for char in self.unicodeScalars {
				if shouldCapitalizeNextChar {
					result = result + "\(char.capitalized)"
				} else {
					result = result + "\(char)"
				}

				if !char.isLetter {
					shouldCapitalizeNextChar = true
				} else {
					shouldCapitalizeNextChar = false
				}
			}

			return result
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

extension String {
	func split(character separator: UnicodeScalar) -> [String] {
		var array = [String]()
		var string = ""

		for char in self.unicodeScalars {
			if char == separator {
				array.append(string)
				string = ""
			} else {
				string.append(char)
			}
		}

		array.append(string)
		string = ""

		return array
	}

	func ekHasPrefix(prefix: String) -> Bool {
		guard self.unicodeScalars.count >= prefix.unicodeScalars.count else {
			return false
		}

		for (a, b) in zip(self.unicodeScalars, prefix.unicodeScalars) {
			if a != b {
				return false
			}
		}

		return true
	}
}
