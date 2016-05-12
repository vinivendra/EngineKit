import UIKit

let OSFactory = EKiOSFactory()

extension UIColor: EKColor {}

public class EKiOSFactory: EKOSFactory {

	public func createFileManager() -> EKFoundationFileManager {
		return EKFoundationFileManager()
	}

	public func createColor(red red: Double,
	                        green: Double,
	                        blue: Double,
	                        alpha: Double) -> UIColor {
		return UIColor(red: CGFloat(red),
		               green: CGFloat(green),
		               blue: CGFloat(blue),
		               alpha: CGFloat(alpha))
	}

}
