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

extension EKVector4: EKColorType {
	public static func createColor(red: Double,
	                                   green: Double,
	                                   blue: Double,
	                                   alpha: Double) -> EKColorType {
		return EKVector4(x: red, y: green, z: blue, w: alpha)
	}

	public var components: (red: Double,
							green: Double,
							blue: Double,
							alpha: Double) {
		get {
			return (x, y, z, w)
		}
	}
}

public protocol EKColorType: class {
	static func createColor(red: Double,
	                        green: Double,
	                        blue: Double,
	                        alpha: Double) -> EKColorType

	var components: (red: Double,
					 green: Double,
					 blue: Double,
					 alpha: Double) { get }
}

public func == (lhs: EKColorType, rhs: EKColorType) -> Bool {
	let r1: Double, g1: Double, b1: Double, a1: Double
	let r2: Double, g2: Double, b2: Double, a2: Double
	(r1, g1, b1, a1) = lhs.components
	(r2, g2, b2, a2) = rhs.components
	return r1 == r2 && g1 == g2 && b1 == b2 && a1 == a2
}

public func != (lhs: EKColorType, rhs: EKColorType) -> Bool {
	return !(lhs == rhs)
}

extension EKColorType {
	func toEKVector4() -> EKVector4 {
		let components = self.components
		return EKVector4.createVector(x: components.red,
		                              y: components.green,
		                              z: components.blue,
		                              w: components.alpha)
	}
}

extension EKColorType {
	static func createColor(red: Double,
	                            green: Double,
	                            blue: Double) -> EKColorType {
		return createColor(red: red, green: green, blue: blue, alpha: 1.0)
	}

	static func createColor(grayscale: Double) -> EKColorType {
		return createColor(red: grayscale,
		                   green: grayscale,
		                   blue: grayscale)
	}

	static func createColor(array: [Double]) -> EKColorType {
		return createColor(red: array[zero: 0],
		                   green: array[zero: 1],
		                   blue: array[zero: 2],
		                   alpha: array[one: 3])
	}

	static func createColor(object: Any) -> EKColorType {
		if let color = object as? EKColorType {
			return color
		} else if let array = object as? [Double] {
			return createColor(array: array)
		} else if let grayscale = object as? Double {
			return createColor(grayscale: grayscale)
		} else if let name = object as? String {
			return createColor(name: name)
		}

		return clearColor()
	}

	static func createColor(name: String) -> EKColorType {
		if let object = EKColorDictionary[name] {
			return createColor(object: object)
		}

		return clearColor()
	}

	static func blackColor() -> EKColorType {
		return createColor(grayscale: 0)
	}

	static func darkGrayColor() -> EKColorType {
		return createColor(grayscale: 0.333)
	}

	static func lightGrayColor() -> EKColorType {
		return createColor(grayscale: 0.667)
	}

	static func whiteColor() -> EKColorType {
		return createColor(grayscale: 1.0)
	}

	static func grayColor() -> EKColorType {
		return createColor(grayscale: 0.5)
	}

	static func redColor() -> EKColorType {
		return createColor(red: 1.0, green: 0.0, blue: 0.0)
	}

	static func greenColor() -> EKColorType {
		return createColor(red: 0.0, green: 1.0, blue: 0.0)
	}

	static func blueColor() -> EKColorType {
		return createColor(red: 0.0, green: 0.0, blue: 1.0)
	}

	static func cyanColor() -> EKColorType {
		return createColor(red: 0.0, green: 1.0, blue: 1.0)
	}

	static func yellowColor() -> EKColorType {
		return createColor(red: 1.0, green: 1.0, blue: 0.0)
	}

	static func magentaColor() -> EKColorType {
		return createColor(red: 1.0, green: 0.0, blue: 1.0)
	}

	static func orangeColor() -> EKColorType {
		return createColor(red: 1.0, green: 0.5, blue: 0.0)
	}

	static func purpleColor() -> EKColorType {
		return createColor(red: 0.5, green: 0.0, blue: 0.5)
	}

	static func brownColor() -> EKColorType {
		return createColor(red: 0.6, green: 0.4, blue: 0.2)
	}

	static func clearColor() -> EKColorType {
		return createColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
	}
}
