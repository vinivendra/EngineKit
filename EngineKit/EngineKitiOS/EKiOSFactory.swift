import UIKit

let OSFactory = EKiOSFactory()

extension UIColor: EKColor {}

public class EKiOSFactory: EKOSFactory {

	// MARK: Manager factory methods
	public func createFileManager() -> EKFoundationFileManager {
		return EKFoundationFileManager()
	}

	// MARK: Color factory methods
	public func blackColor() -> UIColor {
		return UIColor.blackColor()
	}

	public func darkGrayColor() -> UIColor {
		return UIColor.darkGrayColor()
	}

	public func lightGrayColor() -> UIColor {
		return UIColor.lightGrayColor()
	}

	public func whiteColor() -> UIColor {
		return UIColor.whiteColor()
	}

	public func grayColor() -> UIColor {
		return UIColor.grayColor()
	}

	public func redColor() -> UIColor {
		return UIColor.redColor()
	}

	public func greenColor() -> UIColor {
		return UIColor.greenColor()
	}

	public func blueColor() -> UIColor {
		return UIColor.blueColor()
	}

	public func cyanColor() -> UIColor {
		return UIColor.cyanColor()
	}

	public func yellowColor() -> UIColor {
		return UIColor.yellowColor()
	}

	public func magentaColor() -> UIColor {
		return UIColor.magentaColor()
	}

	public func orangeColor() -> UIColor {
		return UIColor.orangeColor()
	}

	public func purpleColor() -> UIColor {
		return UIColor.purpleColor()
	}

	public func brownColor() -> UIColor {
		return UIColor.brownColor()
	}

	public func clearColor() -> UIColor {
		return UIColor.clearColor()
	}

}
