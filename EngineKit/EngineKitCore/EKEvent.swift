public class EKEvent {
}

public protocol EKEventListener {
	func respondToEvent(event: EKEvent)
}

public class EKEventCenter {
	var allListeners = [String: [EKEventListener]]()

	func fireEvent(event: EKEvent) {
		if let listeners = allListeners["\(event.dynamicType)"] {
			for listener in listeners {
				listener.respondToEvent(event)
			}
		}
	}

	func register<Event: EKEvent>(listener: EKEventListener,
	              forEvent event: Event.Type) {
		let className = "\(Event.self)"
		if allListeners[className] == nil {
			allListeners[className] = [EKEventListener]()
		}

		allListeners[className]?.append(listener)
	}
}

public enum EKEventInputState {
	case Began
	case Changed
	case Ended
}

////
public class EKEventScreenInput: EKEvent {
	public let position: (x: Double, y: Double)?

	public init(position: (x: Double, y: Double)? = nil) {
		self.position = position
	}
}

public class EKEventScreenInputContinuous: EKEventScreenInput {
	public let state: EKEventInputState

	public init(position: (x: Double, y: Double)? = nil,
	            state: EKEventInputState) {
		self.state = state
		super.init(position: position)
	}
}

//
public class EKEventTap: EKEventScreenInput {
}

public class EKEventPan: EKEventScreenInputContinuous {
	public let displacement: (x: Double, y: Double)?

	public init(position: (x: Double, y: Double)? = nil,
	            displacement: (x: Double, y: Double)? = nil,
	            state: EKEventInputState) {
		self.displacement = displacement
		super.init(position: position, state: state)
	}
}

public class EKEventPinch: EKEventScreenInputContinuous {
	public let scale: Double?

	public init(position: (x: Double, y: Double)? = nil,
	            scale: Double? = nil,
	            state: EKEventInputState) {
		self.scale = scale
		super.init(position: position, state: state)
	}
}

public class EKEventRotation: EKEventScreenInputContinuous {
	public let angle: Double?

	public init(position: (x: Double, y: Double)? = nil,
	            angle: Double? = nil,
	            state: EKEventInputState) {
		self.angle = angle
		super.init(position: position, state: state)
	}
}

public class EKEventLongPress: EKEventPan {
}
