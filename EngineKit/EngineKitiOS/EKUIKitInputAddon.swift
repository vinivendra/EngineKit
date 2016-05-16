import UIKit

public class EKUIKitInputAddon: EKEventAddon {

	weak public var eventCenter: EKEventCenter?

	public let view: UIView

	public init(view: UIView) {
		self.view = view

		let tapSelector = #selector(EKUIKitInputAddon.handleTap(_:))
		let tapGestureRecognizer = UITapGestureRecognizer(target: self,
		                                                  action: tapSelector)
		self.view.addGestureRecognizer(tapGestureRecognizer)

	}

	public func setup(onEngine engine: EKEngine) throws {
		self.eventCenter = engine.eventCenter
	}

	@objc public func handleTap(gestureRecognizer: UIGestureRecognizer) {
		print("tap!")
	}
}
