import AppKit

private extension NSPoint {
	func toEKVector2() -> EKVector2 {
		return EKVector2(x: Double(self.x), y: Double(-self.y))
	}
}

private extension EKVector2 {
	func toNSPoint() -> NSPoint {
		return NSPoint(x: self.x, y: -self.y)
	}
}

private extension NSEvent {
	var position: EKVector2 {
		get {
			return EKVector2(x: Double(absoluteX),
			                 y: Double(-absoluteY))
		}
	}

	var displacement: EKVector2 {
		get {
			return EKVector2(x: Double(deltaX),
			                 y: Double(-deltaY))
		}
	}
}

public class EKView: NSView {
	var backgroundColor: NSColor = .clearColor()

	override public func drawRect(dirtyRect: NSRect) {
		backgroundColor.setFill()
		NSRectFill(dirtyRect)
		super.drawRect(dirtyRect)
	}
}

extension NSView {
	func addSubviewAndFill(subview: NSView) {
		addSubview(subview)

		let horizontalConstraints =
			NSLayoutConstraint.constraintsWithVisualFormat(
			"|[subview]|",
			options: NSLayoutFormatOptions(rawValue: 0),
			metrics: nil,
			views: ["subview": subview])
		let verticalConstraints =
			NSLayoutConstraint.constraintsWithVisualFormat(
			"V:|[subview]|",
			options: NSLayoutFormatOptions(rawValue: 0),
			metrics: nil,
			views: ["subview": subview])

		subview.translatesAutoresizingMaskIntoConstraints = false

		addConstraints(horizontalConstraints)
		addConstraints(verticalConstraints)
	}
}

public final class EKAppKitInputView: EKView {
	weak public var eventCenter: EKEventCenter?

	var tapIsPossible = true
	var panIsBeggining = false
	var pinchIsHappening = false

	override public func mouseUp(event: NSEvent) {
		if tapIsPossible {
			eventCenter?.fireEvent(EKEventTap(
				position: event.position,
				touches: 1))
		} else {
			eventCenter?.fireEvent(EKEventPan(
				position: event.position,
				touches: 1,
				displacement: EKVector2.origin(),
				state: .Ended))
		}
	}

	override public func mouseDown(event: NSEvent) {
		window?.acceptsMouseMovedEvents = true

		tapIsPossible = true
		panIsBeggining = false
	}

	override public func mouseDragged(event: NSEvent) {
		if panIsBeggining {
			panIsBeggining = false
			tapIsPossible = false

			eventCenter?.fireEvent(EKEventPan(
				position: event.position,
				touches: 1,
				displacement: event.displacement,
				state: .Began))
		} else if tapIsPossible {
			panIsBeggining = true
		} else {
			eventCenter?.fireEvent(EKEventPan(
				position: event.position,
				touches: 1,
				displacement: event.displacement,
				state: .Changed))
		}
	}

	override public func magnifyWithEvent(event: NSEvent) {
		if !pinchIsHappening {
			pinchIsHappening = true

			eventCenter?.fireEvent(EKEventPinch(
				position: NSEvent.mouseLocation().toEKVector2(),
				touches: 1,
				scale: 1,
				state: .Began))
		} else if event.magnification == 0.0 {
			pinchIsHappening = false

			eventCenter?.fireEvent(EKEventPinch(
				position: NSEvent.mouseLocation().toEKVector2(),
				touches: 1,
				scale: 1,
				state: .Ended))
		} else {
			eventCenter?.fireEvent(EKEventPinch(
				position: NSEvent.mouseLocation().toEKVector2(),
				touches: 1,
				scale: Double(1 + event.magnification),
				state: .Changed))
		}
	}
}

public class EKAppKitInputAddon: EKEventAddon {

	weak public var eventCenter: EKEventCenter? {
		get {
			return inputView.eventCenter
		}
		set {
			inputView.eventCenter = newValue
		}
	}

	public var firesEventsOfTypes: [EKEvent.Type] {
		get {
			return [EKEventTap.self, EKEventPan.self, EKEventPinch.self,
			        EKEventRotation.self, EKEventLongPress.self]
		}
	}

	var previousPosition = EKVector2.origin()
	var previousScale: CGFloat = 1
	var previousAngle: CGFloat = 0

	var numberOfTouches: Int!

	let view: NSView
	let inputView: EKAppKitInputView

	public init(view: NSView) {
		self.view = view
		self.inputView = view.subviews.map {
			$0 as? EKAppKitInputView
			}.flatMap { $0 }.first ?? EKAppKitInputView(frame: NSRect(x: 10,
				y: 10,
				width: 100,
				height: 100))

		view.addSubviewAndFill(inputView)
	}

//	@objc public func handlePinch(gestureRecognizer: NSPinchGestureRecognizer) {
//		let point = gestureRecognizer.locationInView(view)
//
//		switch gestureRecognizer.state {
//		case .Began:
//			numberOfTouches = gestureRecognizer.numberOfTouches()
//
//			eventCenter?.fireEvent(EKEventPinch(position: point.toEKVector2(),
//				touches: numberOfTouches,
//				scale: 1,
//				state: .Began))
//		case .Ended:
//			eventCenter?.fireEvent(EKEventPinch(position: point.toEKVector2(),
//				touches: numberOfTouches,
//				scale: Double(gestureRecognizer.scale / previousScale),
//				state: .Ended))
//		default:
//			eventCenter?.fireEvent(EKEventPinch(position: point.toEKVector2(),
//				touches: numberOfTouches,
//				scale: Double(gestureRecognizer.scale / previousScale),
//				state: .Changed))
//		}
//
//		previousScale = gestureRecognizer.scale
//	}
//
//	@objc public func handleRotation(
//		gestureRecognizer: NSRotationGestureRecognizer) {
//
//		let point = gestureRecognizer.locationInView(view)
//
//		switch gestureRecognizer.state {
//		case .Began:
//			numberOfTouches = gestureRecognizer.numberOfTouches()
//
//			eventCenter?.fireEvent(EKEventRotation(
//				position: point.toEKVector2(),
//				touches: numberOfTouches,
//				angle: 0,
//				state: .Began))
//		case .Ended:
//			eventCenter?.fireEvent(EKEventRotation(
//				position: point.toEKVector2(),
//				touches: numberOfTouches,
//				angle: Double(gestureRecognizer.rotation - previousAngle),
//				state: .Ended))
//		default:
//			eventCenter?.fireEvent(EKEventRotation(
//				position: point.toEKVector2(),
//				touches: numberOfTouches,
//				angle: Double(gestureRecognizer.rotation - previousAngle),
//				state: .Changed))
//		}
//
//		previousAngle = gestureRecognizer.rotation
//	}
//
//	@objc public func handleLongPress(gestureRecognizer: NSGestureRecognizer) {
//		let point = gestureRecognizer.locationInView(view)
//
//		if gestureRecognizer.state == .Began {
//			numberOfTouches = gestureRecognizer.numberOfTouches()
//		}
//
//		eventCenter?.fireEvent(EKEventLongPress(position: point.toEKVector2(),
//			touches: gestureRecognizer.numberOfTouches(),
//			displacement: EKVector2.origin(), state: .Changed))
//	}
}
