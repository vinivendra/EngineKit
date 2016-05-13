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
