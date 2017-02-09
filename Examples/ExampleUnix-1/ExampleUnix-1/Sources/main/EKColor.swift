let EKColorDictionary: [String: Any] =
	["black": 0.0,
	 "darkGray": 0.333,
	 "lightGray": 0.667,
	 "darkGrey": "darkGray",
	 "lightGrey": "lightGray",
	 "white": 1.0,
	 "gray": 0.5,
	 "grey": "gray",
	 "red": [1.0, 0.0, 0.0],
	 "green": [0.0, 1.0, 0.0],
	 "blue": [0.0, 0.0, 1.0],
	 "cyan": [0.0, 1.0, 1.0],
	 "yellow": [1.0, 1.0, 0.0],
	 "magenta": [1.0, 0.0, 1.0],
	 "orange": [1.0, 0.5, 0.0],
	 "purple": [0.5, 0.0, 0.5],
	 "brown": [0.6, 0.4, 0.2],
	 "clear": [0.0, 0.0, 0.0, 0.0]]

public func == (lhs: EKColor, rhs: EKColor) -> Bool {
	return lhs.r == rhs.r && lhs.g == rhs.g && lhs.b == rhs.b && lhs.a == rhs.a
}

public func != (lhs: EKColor, rhs: EKColor) -> Bool {
	return !(lhs == rhs)
}

extension EKColor {
	public func toEKVector4() -> EKVector4 {
		return EKVector4(x: r, y: g, z: b, w: a)
	}

	public func toArray() -> [Double] {
		return [r, g, b, a]
	}
}

extension EKColor {
	public func plus(_ color: EKColor) -> EKColor {
		return EKColor(withRed: self.r + color.r,
		               green: self.g + color.g,
		               blue: self.b + color.b,
		               alpha: self.a + color.a)
	}

	public func minus(_ color: EKColor) -> EKColor {
		return EKColor(withRed: self.r - color.r,
		               green: self.g - color.g,
		               blue: self.b - color.b,
		               alpha: self.a - color.a)
	}

	public func times(_ scalar: Double) -> EKColor {
		return EKColor(withRed: self.r * scalar,
		               green: self.g * scalar,
		               blue: self.b * scalar,
		               alpha: self.a * scalar)
	}

	public func over(_ scalar: Double) -> EKColor {
		return self.times(1/scalar)
	}
}

extension EKColor {
	init(withRed red: Double,
	     green: Double,
	     blue: Double) {
		self.init(withRed: red, green: green, blue: blue, alpha: 1.0)
	}

	init(inGrayscale grayscale: Double) {
		self.init(withRed: grayscale, green: grayscale, blue: grayscale)
	}

	init(fromArray array: [Double]) {
		self.init(withRed: array[zero: 0],
		               green: array[zero: 1],
		               blue: array[zero: 2],
		               alpha: array[one: 3])
	}

	init(fromValue value: Any) {
		if let color = value as? EKColor {
			self.init(withRed: color.r,
			          green: color.g,
			          blue: color.b,
			          alpha: color.a)
		} else if let array = value as? [Double] {
			self.init(fromArray: array)
		} else if let grayscale = value as? Double {
			self.init(inGrayscale: grayscale)
		} else if let name = value as? String {
			self.init(withName: name)
		} else {
			self.init(withName: "clear")
		}
	}

	init(withName name: String) {
		if let value = EKColorDictionary[name] {
			self.init(fromValue: value)
		} else {
			self.init(withName: "clear")
		}
	}

	static func blackColor() -> EKColor {
		return EKColor(inGrayscale: 0)
	}

	static func darkGrayColor() -> EKColor {
		return EKColor(inGrayscale: 0.333)
	}

	static func lightGrayColor() -> EKColor {
		return EKColor(inGrayscale: 0.667)
	}

	static func whiteColor() -> EKColor {
		return EKColor(inGrayscale: 1.0)
	}

	static func grayColor() -> EKColor {
		return EKColor(inGrayscale: 0.5)
	}

	static func redColor() -> EKColor {
		return EKColor(withRed: 1.0, green: 0.0, blue: 0.0)
	}

	static func greenColor() -> EKColor {
		return EKColor(withRed: 0.0, green: 1.0, blue: 0.0)
	}

	static func blueColor() -> EKColor {
		return EKColor(withRed: 0.0, green: 0.0, blue: 1.0)
	}

	static func cyanColor() -> EKColor {
		return EKColor(withRed: 0.0, green: 1.0, blue: 1.0)
	}

	static func yellowColor() -> EKColor {
		return EKColor(withRed: 1.0, green: 1.0, blue: 0.0)
	}

	static func magentaColor() -> EKColor {
		return EKColor(withRed: 1.0, green: 0.0, blue: 1.0)
	}

	static func orangeColor() -> EKColor {
		return EKColor(withRed: 1.0, green: 0.5, blue: 0.0)
	}

	static func purpleColor() -> EKColor {
		return EKColor(withRed: 0.5, green: 0.0, blue: 0.5)
	}

	static func brownColor() -> EKColor {
		return EKColor(withRed: 0.6, green: 0.4, blue: 0.2)
	}

	static func clearColor() -> EKColor {
		return EKColor(withRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
	}
}
