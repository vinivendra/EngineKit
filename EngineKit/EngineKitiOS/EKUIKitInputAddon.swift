import UIKit

extension CGPoint {
	func toEKVector2() -> EKVector2 {
		return EKVector2(x: Double(self.x), y: Double(-self.y))
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

	var previousPosition = EKVector2.origin()
	var numberOfTouches: Int!

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
		eventCenter?.fireEvent(EKEventTap(position: point.toEKVector2(),
			touches: gestureRecognizer.numberOfTouches()))
	}

	@objc public func handlePan(gestureRecognizer: UIGestureRecognizer) {
		let point = gestureRecognizer.locationInView(view)

		switch gestureRecognizer.state {
		case .Began:
			numberOfTouches = gestureRecognizer.numberOfTouches()

			eventCenter?.fireEvent(EKEventPan(position: point.toEKVector2(),
				touches: numberOfTouches,
				displacement: EKVector2.origin(), state: .Began))
		case .Ended:
			eventCenter?.fireEvent(EKEventPan(position: point.toEKVector2(),
				touches: numberOfTouches,
				displacement: point.toEKVector2().minus(previousPosition),
					state: .Ended))
		default:
			eventCenter?.fireEvent(EKEventPan(position: point.toEKVector2(),
				touches: numberOfTouches,
				displacement: point.toEKVector2().minus(previousPosition),
				state: .Changed))
		}

		previousPosition = point.toEKVector2()
	}

	@objc public func handlePinch(gestureRecognizer: UIGestureRecognizer) {
		let point = gestureRecognizer.locationInView(view)

		if gestureRecognizer.state == .Began {
			numberOfTouches = gestureRecognizer.numberOfTouches()
		}

		eventCenter?.fireEvent(EKEventPinch(position: point.toEKVector2(),
			touches: gestureRecognizer.numberOfTouches(),
			scale: 1, state: .Changed))
	}

	@objc public func handleRotation(gestureRecognizer: UIGestureRecognizer) {
		let point = gestureRecognizer.locationInView(view)

		if gestureRecognizer.state == .Began {
			numberOfTouches = gestureRecognizer.numberOfTouches()
		}

		eventCenter?.fireEvent(EKEventRotation(position: point.toEKVector2(),
			touches: gestureRecognizer.numberOfTouches(),
			angle: 0, state: .Changed))
	}

	@objc public func handleLongPress(gestureRecognizer: UIGestureRecognizer) {
		let point = gestureRecognizer.locationInView(view)

		if gestureRecognizer.state == .Began {
			numberOfTouches = gestureRecognizer.numberOfTouches()
		}

		eventCenter?.fireEvent(EKEventLongPress(position: point.toEKVector2(),
			touches: gestureRecognizer.numberOfTouches(),
			displacement: EKVector2.origin(), state: .Changed))
	}
}
