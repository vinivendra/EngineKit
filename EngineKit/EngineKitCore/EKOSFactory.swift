public protocol EKOSFactory {
	associatedtype Color: EKColor
	associatedtype FileManager: EKFileManager

	func createFileManager() -> FileManager

	func createColor(red red: Double,
	                 green: Double,
	                 blue: Double,
	                 alpha: Double) -> Color
}

extension EKOSFactory {

	func createColor(red red: Double, green: Double, blue: Double) -> Color {
		return createColor(red: red, green: green, blue: blue, alpha: 1.0)
	}

	func createColor(grayscale grayscale: Double) -> Color {
		return createColor(red: grayscale,
		                   green: grayscale,
		                   blue: grayscale,
		                   alpha: 1.0)
	}

	func createColor(fromArray array: [Double]) -> Color {
		return createColor(red: array[zero: 0],
		                   green: array[zero: 1],
		                   blue: array[zero: 2],
		                   alpha: array[one: 3])
	}

	func createColor(withObject object: AnyObject) -> Color {
		if let color = object as? Color {
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

	func createColor(named name: String) -> Color {
		if let object = EKColorDictionary[name] {
			return createColor(withObject: object)
		}

		return clearColor()
	}

	func blackColor() -> Color {
		return createColor(grayscale: 0)
	}

	func darkGrayColor() -> Color {
		return createColor(grayscale: 0.333)
	}

	func lightGrayColor() -> Color {
		return createColor(grayscale: 0.667)
	}

	func whiteColor() -> Color {
		return createColor(grayscale: 1.0)
	}

	func grayColor() -> Color {
		return createColor(grayscale: 0.5)
	}

	func redColor() -> Color {
		return createColor(red: 1.0, green: 0.0, blue: 0.0)
	}

	func greenColor() -> Color {
		return createColor(red: 0.0, green: 1.0, blue: 0.0)
	}

	func blueColor() -> Color {
		return createColor(red: 0.0, green: 0.0, blue: 1.0)
	}

	func cyanColor() -> Color {
		return createColor(red: 0.0, green: 1.0, blue: 1.0)
	}

	func yellowColor() -> Color {
		return createColor(red: 1.0, green: 1.0, blue: 0.0)
	}

	func magentaColor() -> Color {
		return createColor(red: 1.0, green: 0.0, blue: 1.0)
	}

	func orangeColor() -> Color {
		return createColor(red: 1.0, green: 0.5, blue: 0.0)
	}

	func purpleColor() -> Color {
		return createColor(red: 0.5, green: 0.0, blue: 0.5)
	}

	func brownColor() -> Color {
		return createColor(red: 0.6, green: 0.4, blue: 0.2)
	}

	func clearColor() -> Color {
		return createColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
	}
}
