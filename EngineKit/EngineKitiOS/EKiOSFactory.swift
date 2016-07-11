import UIKit

let OSFactory = EKiOSFactory()

extension UIColor: EKColorType {
	public static func createColor(red: Double,
	                               green: Double,
	                               blue: Double,
	                               alpha: Double) -> EKColorType {
		return UIColor(red: CGFloat(red),
		               green: CGFloat(green),
		               blue: CGFloat(blue),
		               alpha: CGFloat(alpha))
	}

	public var components: (red: Double,
		green: Double,
		blue: Double,
		alpha: Double) {

		var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
		getRed(&r, green: &g, blue: &b, alpha: &a)
		return (Double(r), Double(g), Double(b), Double(a))
	}
}

public class EKiOSFactory: EKOSFactory {
	public func createFileManager() -> EKFoundationFileManager {
		return EKFoundationFileManager()
	}
}
