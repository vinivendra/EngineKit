import UIKit

public class EKUIKitInputAddon: EKEventAddon {

	weak public var eventCenter: EKEventCenter?

	public let view: UIView

	public init(view: UIView) {
		self.view = view

		let tapGestureRecognizer = UITapGestureRecognizer(
			target: self, action: #selector(EKUIKitInputAddon.handleTap(_:)))
		self.view.addGestureRecognizer(tapGestureRecognizer)

		let panGestureRecognizer = UIPanGestureRecognizer(
			target: self, action: #selector(EKUIKitInputAddon.handlePan(_:)))
		self.view.addGestureRecognizer(panGestureRecognizer)

		let pinchGestureRecognizer = UIPinchGestureRecognizer(
			target: self, action: #selector(EKUIKitInputAddon.handlePinch(_:)))
		self.view.addGestureRecognizer(pinchGestureRecognizer)

		let rotationGestureRecognizer = UIRotationGestureRecognizer(
			target: self,
			action: #selector(EKUIKitInputAddon.handleRotation(_:)))
		self.view.addGestureRecognizer(rotationGestureRecognizer)

		let longPressGestureRecognizer = UILongPressGestureRecognizer(
			target: self,
			action: #selector(EKUIKitInputAddon.handleLongPress(_:)))
		self.view.addGestureRecognizer(longPressGestureRecognizer)
	}

	public func setup(onEngine engine: EKEngine) throws {
		self.eventCenter = engine.eventCenter
	}

	@objc public func handleTap(gestureRecognizer: UIGestureRecognizer) {
		print("tap!")
	}

	@objc public func handlePan(gestureRecognizer: UIGestureRecognizer) {
		print("pan!")
	}

	@objc public func handlePinch(gestureRecognizer: UIGestureRecognizer) {
		print("pinch!")
	}

	@objc public func handleRotation(gestureRecognizer: UIGestureRecognizer) {
		print("rotation!")
	}

	@objc public func handleLongPress(gestureRecognizer: UIGestureRecognizer) {
		print("long press!")
	}
}
