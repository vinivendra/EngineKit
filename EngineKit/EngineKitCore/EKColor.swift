let EKColorDictionary =
	["black": 0.0,
	 "darkGray": 0.333,
	 "lightGray": 0.667,
	 "darkGrey": "darkGray",
	 "lightGrey": "lightGray",
	 "white": 1.0,
	 "gray": 0.5,
	 "grey": "gray",
	 "red": [1, 0, 0],
	 "green": [0, 1, 0],
	 "blue": [0, 0, 1],
	 "cyan": [0, 1, 1],
	 "yellow": [1, 1, 0],
	 "magenta": [1, 0, 1],
	 "orange": [1, 0.5, 0],
	 "purple": [0.5, 0, 0.5],
	 "brown": [0.6, 0.4, 0.2],
	 "clear": [0, 0, 0, 0]]

public protocol EKColor: class {
	static func createColor(red red: Double,
	                            green: Double,
	                            blue: Double,
	                            alpha: Double) -> EKColor

	var components: (red: Double,
					 green: Double,
					 blue: Double,
					 alpha: Double) { get }
}

extension EKColor {
	static func createColor(red red: Double,
	                            green: Double,
	                            blue: Double) -> EKColor {
		return createColor(red: red, green: green, blue: blue, alpha: 1.0)
	}

	static func createColor(grayscale grayscale: Double) -> EKColor {
		return createColor(red: grayscale,
		                   green: grayscale,
		                   blue: grayscale,
		                   alpha: 1.0)
	}

	static func createColor(fromArray array: [Double]) -> EKColor {
		return createColor(red: array[zero: 0],
		                   green: array[zero: 1],
		                   blue: array[zero: 2],
		                   alpha: array[one: 3])
	}

	static func createColor(withObject object: Any) -> EKColor {
		if let color = object as? EKColor {
			return color
		} else if let array = object as? [Double] {
			return createColor(fromArray: array)
		} else if let grayscale = object as? Double {
			return createColor(grayscale: grayscale)
		} else if let name = object as? String {
			return createColor(named: name)
		}

		return clearColor()
	}

	static func createColor(named name: String) -> EKColor {
		if let object = EKColorDictionary[name] {
			return createColor(withObject: object)
		}

		return clearColor()
	}

	static func blackColor() -> EKColor {
		return createColor(grayscale: 0)
	}

	static func darkGrayColor() -> EKColor {
		return createColor(grayscale: 0.333)
	}

	static func lightGrayColor() -> EKColor {
		return createColor(grayscale: 0.667)
	}

	static func whiteColor() -> EKColor {
		return createColor(grayscale: 1.0)
	}

	static func grayColor() -> EKColor {
		return createColor(grayscale: 0.5)
	}

	static func redColor() -> EKColor {
		return createColor(red: 1.0, green: 0.0, blue: 0.0)
	}

	static func greenColor() -> EKColor {
		return createColor(red: 0.0, green: 1.0, blue: 0.0)
	}

	static func blueColor() -> EKColor {
		return createColor(red: 0.0, green: 0.0, blue: 1.0)
	}

	static func cyanColor() -> EKColor {
		return createColor(red: 0.0, green: 1.0, blue: 1.0)
	}

	static func yellowColor() -> EKColor {
		return createColor(red: 1.0, green: 1.0, blue: 0.0)
	}

	static func magentaColor() -> EKColor {
		return createColor(red: 1.0, green: 0.0, blue: 1.0)
	}

	static func orangeColor() -> EKColor {
		return createColor(red: 1.0, green: 0.5, blue: 0.0)
	}

	static func purpleColor() -> EKColor {
		return createColor(red: 0.5, green: 0.0, blue: 0.5)
	}

	static func brownColor() -> EKColor {
		return createColor(red: 0.6, green: 0.4, blue: 0.2)
	}

	static func clearColor() -> EKColor {
		return createColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
	}

}
