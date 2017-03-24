import CGLFW3

public final class EKUnixInputAddon: EKEventAddon {
	let handler = EKScreenInputHandler()
	let window: OpaquePointer

	var width: CInt = 0
	var height: CInt = 0

	weak public var eventCenter: EKEventCenter? {
		get {
			return handler.eventCenter
		}
		set {
			handler.eventCenter = newValue
		}
	}

	public var firesEventsOfTypes: [EKEvent.Type] {
		return handler.firesEventsOfTypes
	}

	var oldMouseButtonState: CInt = GLFW_RELEASE
	var oldMousePosition = EKVector2()

	//
	init(window: OpaquePointer) {
		self.window = window
	}

	public func update() {
		glfwGetWindowSize(window, &width, &height)

		var xPosition: CDouble = 0
		var yPosition: CDouble = 0
		glfwGetCursorPos(window, &xPosition, &yPosition)
		let newMousePosition = EKVector2(x: xPosition,
		                                 y: CDouble(height) - yPosition)
		let newMouseButtonState = glfwGetMouseButton(window,
		                                             GLFW_MOUSE_BUTTON_LEFT)

		switch (oldMouseButtonState, newMouseButtonState) {
		case (GLFW_RELEASE, GLFW_PRESS):
			handler.mouseDown(atPosition: newMousePosition)
		case (GLFW_PRESS, GLFW_RELEASE):
			handler.mouseUp(atPosition: newMousePosition)
		case (GLFW_PRESS, GLFW_PRESS)
			where newMousePosition != oldMousePosition:

			let displacement = newMousePosition.minus(oldMousePosition)
			handler.mouseDragged(atPosition: newMousePosition,
			                     displacement: displacement)
		default:
			// hover?
			break
		}

		oldMouseButtonState = newMouseButtonState
		oldMousePosition = newMousePosition
	}
}

public final class EKScreenInputHandler {
	weak public var eventCenter: EKEventCenter?

	public var firesEventsOfTypes: [EKEvent.Type] {
		return [EKEventScreenInput.self,
		        EKEventScreenInputContinuous.self,
		        EKEventTap.self,
		        EKEventPan.self,
		        EKEventLongPress.self]
	}

	var longPressTriggered = false
	var longPressTimer: EKTimer?

	enum GestureRecognizerState {
		case standby
		case detected
		case detectedTolerance
		case performingLongGesture
	}

	var state = GestureRecognizerState.standby

	private func longPressDelayExpired() {
		switch state {
		case .performingLongGesture:
			break
		default:
			longPressTriggered = true
		}
	}

	public func mouseUp(atPosition position: EKVector2) {
		let eventToFire: EKEvent

		longPressTimer?.invalidate()

		switch state {
		case .performingLongGesture:
			if longPressTriggered {
				eventToFire = EKEventLongPress(
					position: position,
					touches: 1,
					displacement: EKVector2(),
					state: .ended)
			} else {
				eventToFire = EKEventPan(
					position: position,
					touches: 1,
					displacement: EKVector2(),
					state: .ended)
			}
		default:
			eventToFire = EKEventTap(
				position: position,
				touches: 1)
		}

		eventCenter?.fireEvent(eventToFire)

		state = .standby
	}

	public func mouseDown(atPosition position: EKVector2) {
		state = .detected

		longPressTriggered = false

		longPressTimer = EKTimer(duration: 0.5) {
			self.longPressDelayExpired()
		}
		longPressTimer!.start()
	}

	public func mouseDragged(atPosition position: EKVector2,
	                         displacement: EKVector2) {
		var stateOfEventToFire: EKEventInputState? = nil

		switch state {
		case .detected:
			state = .detectedTolerance
		case .detectedTolerance:
			state = .performingLongGesture
			stateOfEventToFire = .began
		case .performingLongGesture:
			stateOfEventToFire = .changed
		default: break
		}

		if let stateOfEventToFire = stateOfEventToFire {
			let eventToFire: EKEvent

			if longPressTriggered {
				eventToFire = EKEventLongPress(
					position: position,
					touches: 1,
					displacement: displacement,
					state: stateOfEventToFire)
			} else {
				eventToFire = EKEventPan(
					position: position,
					touches: 1,
					displacement: displacement,
					state: stateOfEventToFire)
			}
			eventCenter?.fireEvent(eventToFire)
		}
	}
}
