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

	var longPressTriggered = false
	var pinchIsHappening = false
	var rotationIsHappening = false

	enum GestureRecognizerState {
		case Standby
		case Detected
		case DetectedTolerance
		case PerformingLongGesture
	}

	var state = GestureRecognizerState.Standby

	func longPressDelayExpired() {
		switch state {
		case .PerformingLongGesture:
			break
		default:
			longPressTriggered = true
		}
	}

	override public func mouseUp(event: NSEvent) {
		let eventToFire: EKEvent

		switch state {
		case .PerformingLongGesture:
			if longPressTriggered {
				eventToFire = EKEventLongPress(
					position: event.position,
					touches: 1,
					displacement: EKVector2.origin(),
					state: .Ended)
			} else {
				eventToFire = EKEventPan(
					position: event.position,
					touches: 1,
					displacement: EKVector2.origin(),
					state: .Ended)
			}
		default:
			eventToFire = EKEventTap(
				position: event.position,
				touches: 1)
		}

		eventCenter?.fireEvent(eventToFire)

		state = .Standby
	}

	override public func mouseDown(event: NSEvent) {
		window?.acceptsMouseMovedEvents = true

		state = .Detected

		longPressTriggered = false

		NSTimer.scheduledTimerWithTimeInterval(
			0.5,
			target: self,
			selector: #selector(longPressDelayExpired),
			userInfo: nil,
			repeats: false)
	}

	override public func mouseDragged(event: NSEvent) {
		var stateOfEventToFire: EKEventInputState? = nil

		switch state {
		case .Detected:
			state = .DetectedTolerance
		case .DetectedTolerance:
			state = .PerformingLongGesture
			stateOfEventToFire = .Began
		case .PerformingLongGesture:
			stateOfEventToFire = .Changed
		default: break
		}

		if let stateOfEventToFire = stateOfEventToFire {
			let eventToFire: EKEvent

			if longPressTriggered {
				eventToFire = EKEventLongPress(
					position: event.position,
					touches: 1,
					displacement: event.displacement,
					state: stateOfEventToFire)
			} else {
				eventToFire = EKEventPan(
					position: event.position,
					touches: 1,
					displacement: event.displacement,
					state: stateOfEventToFire)
			}

			eventCenter?.fireEvent(eventToFire)
		}
	}

	override public func magnifyWithEvent(event: NSEvent) {
		let position = NSEvent.mouseLocation().toEKVector2()
		let scale = Double(1 + event.magnification)

		let state: EKEventInputState

		if !pinchIsHappening {
			pinchIsHappening = true
			state = .Began
		} else if event.magnification == 0.0 {
			pinchIsHappening = false
			state = .Ended
		} else {
			state = .Changed
		}

		eventCenter?.fireEvent(EKEventPinch(
			position: position,
			touches: 1,
			scale: scale,
			state: state))
	}

	override public func rotateWithEvent(event: NSEvent) {
		let position = NSEvent.mouseLocation().toEKVector2()
		let rotation = Double(event.rotation)
		let angle = -rotation / 180 * M_PI

		let state: EKEventInputState

		if !rotationIsHappening {
			rotationIsHappening = true
			state = .Began
		} else if event.rotation == 0.0 {
			rotationIsHappening = false
			state = .Ended
		} else {
			state = .Changed
		}

		eventCenter?.fireEvent(EKEventRotation(
			position: position,
			touches: 1,
			angle: angle,
			state: state))
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
			return [EKEventScreenInput.self, EKEventScreenInputContinuous.self,
			        EKEventTap.self, EKEventPan.self, EKEventPinch.self,
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
}
