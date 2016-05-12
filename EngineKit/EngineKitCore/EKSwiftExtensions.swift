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
