public protocol EKOSFactory {
	associatedtype Color: EKColor
	associatedtype FileManager: EKFileManager

	func createFileManager() -> FileManager

	func blackColor() -> Color
	func darkGrayColor() -> Color
	func lightGrayColor() -> Color
	func whiteColor() -> Color
	func grayColor() -> Color
	func redColor() -> Color
	func greenColor() -> Color
	func blueColor() -> Color
	func cyanColor() -> Color
	func yellowColor() -> Color
	func magentaColor() -> Color
	func orangeColor() -> Color
	func purpleColor() -> Color
	func brownColor() -> Color
	func clearColor() -> Color
}
