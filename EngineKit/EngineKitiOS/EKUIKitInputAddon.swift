import UIKit

extension CGPoint {
	var doubleTuple: (x: Double, y: Double) {
		get {
			return (x: Double(self.x), y: Double(self.y))
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
		eventCenter?.fireEvent(EKEventTap(position: point.doubleTuple))
	}

	@objc public func handlePan(gestureRecognizer: UIGestureRecognizer) {
		let point = gestureRecognizer.locationInView(view)
		eventCenter?.fireEvent(EKEventPan(position: point.doubleTuple,
			displacement: nil, state: .Changed))
	}

	@objc public func handlePinch(gestureRecognizer: UIGestureRecognizer) {
		let point = gestureRecognizer.locationInView(view)
		eventCenter?.fireEvent(EKEventPinch(position: point.doubleTuple,
			scale: nil, state: .Changed))
	}

	@objc public func handleRotation(gestureRecognizer: UIGestureRecognizer) {
		let point = gestureRecognizer.locationInView(view)
		eventCenter?.fireEvent(EKEventRotation(position: point.doubleTuple,
			angle: nil, state: .Changed))
	}

	@objc public func handleLongPress(gestureRecognizer: UIGestureRecognizer) {
		let point = gestureRecognizer.locationInView(view)
		eventCenter?.fireEvent(EKEventLongPress(position: point.doubleTuple,
			displacement: nil, state: .Changed))
	}
}
