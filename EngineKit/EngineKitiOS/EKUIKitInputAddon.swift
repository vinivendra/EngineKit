import UIKit

extension CGPoint: EKVector2Type {
	public static func createVector(x x: Double,
	                                  y: Double) -> CGPoint {
		return CGPoint(x: x, y: y)
	}

	public var x: Double {
		get {
			let float: CGFloat = self.x
			return Double(float)
		}
	}
	public var y: Double {
		get {
			let float: CGFloat = self.y
			return Double(float)
		}
	}
}

public class EKUIKitInputAddon: EKEventAddon {

	weak public var eventCenter: EKEventCenter?
	public var firesEventsOfTypes: [EKEvent.Type] {
		get {
			return [EKEventTap.self, EKEventPan.self, EKEventPinch.self,
			        EKEventRotation.self, EKEventLongPress.self]
		}
	}

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

	@objc public func handleTap(gestureRecognizer: UIGestureRecognizer) {
		let point = gestureRecognizer.locationInView(view)
		eventCenter?.fireEvent(EKEventTap(position: point))
	}

	@objc public func handlePan(gestureRecognizer: UIGestureRecognizer) {
		let point = gestureRecognizer.locationInView(view)
		eventCenter?.fireEvent(EKEventPan(position: point,
			displacement: CGPoint.origin(), state: .Changed))
	}

	@objc public func handlePinch(gestureRecognizer: UIGestureRecognizer) {
		let point = gestureRecognizer.locationInView(view)
		eventCenter?.fireEvent(EKEventPinch(position: point,
			scale: 1, state: .Changed))
	}

	@objc public func handleRotation(gestureRecognizer: UIGestureRecognizer) {
		let point = gestureRecognizer.locationInView(view)
		eventCenter?.fireEvent(EKEventRotation(position: point,
			angle: 0, state: .Changed))
	}

	@objc public func handleLongPress(gestureRecognizer: UIGestureRecognizer) {
		let point = gestureRecognizer.locationInView(view)
		eventCenter?.fireEvent(EKEventLongPress(position: point,
			displacement: CGPoint.origin(), state: .Changed))
	}
}
