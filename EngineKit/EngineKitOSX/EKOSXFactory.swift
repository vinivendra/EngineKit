import Cocoa

let OSFactory = EKOSXFactory()

extension NSColor: EKColor {}

public class EKOSXFactory: EKOSFactory {

	// MARK: Manager factory methods
	public func createFileManager() -> EKFileManager {
		return EKFoundationFileManager()
	}

	// MARK: Color factory methods
	public func blackColor() -> NSColor {
		return NSColor.blackColor()
	}

	public func darkGrayColor() -> NSColor {
		return NSColor.darkGrayColor()
	}

	public func lightGrayColor() -> NSColor {
		return NSColor.lightGrayColor()
	}

	public func whiteColor() -> NSColor {
		return NSColor.whiteColor()
	}

	public func grayColor() -> NSColor {
		return NSColor.grayColor()
	}

	public func redColor() -> NSColor {
		return NSColor.redColor()
	}

	public func greenColor() -> NSColor {
		return NSColor.greenColor()
	}

	public func blueColor() -> NSColor {
		return NSColor.blueColor()
	}

	public func cyanColor() -> NSColor {
		return NSColor.cyanColor()
	}

	public func yellowColor() -> NSColor {
		return NSColor.yellowColor()
	}

	public func magentaColor() -> NSColor {
		return NSColor.magentaColor()
	}

	public func orangeColor() -> NSColor {
		return NSColor.orangeColor()
	}

	public func purpleColor() -> NSColor {
		return NSColor.purpleColor()
	}

	public func brownColor() -> NSColor {
		return NSColor.brownColor()
	}

	public func clearColor() -> NSColor {
		return NSColor.clearColor()
	}

}
