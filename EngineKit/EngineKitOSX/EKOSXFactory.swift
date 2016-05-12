import Cocoa

let OSFactory = EKOSXFactory()

extension NSColor: EKColor {}

public class EKOSXFactory: EKOSFactory {

	public func createFileManager() -> EKFoundationFileManager {
		return EKFoundationFileManager()
	}

	public func createColor(red red: Double,
	                            green: Double,
	                            blue: Double,
	                            alpha: Double) -> NSColor {
		return NSColor(red: CGFloat(red),
		               green: CGFloat(green),
		               blue: CGFloat(blue),
		               alpha: CGFloat(alpha))
	}

}
