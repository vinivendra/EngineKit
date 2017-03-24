public protocol EKAction {
	@discardableResult
	func callWithArgument(_ argument: Any?) throws -> Any?
}

public struct EKFunctionVoidAction<ReturnType>: EKAction {
	let closure: () -> (ReturnType)

	@discardableResult
	public func callWithArgument(_ argument: Any?) throws -> Any? {
		return closure()
	}
}

public struct EKFunctionAction<ArgumentType, ReturnType>: EKAction {
	let closure: (ArgumentType) -> (ReturnType)

	@discardableResult
	public func callWithArgument(_ argument: Any?) throws -> Any? {
		if let typedArgument = argument as? ArgumentType {
			return closure(typedArgument)
		} else {
			let argument = argument ?? "nil"
			let message = "Expected argument of type \(ArgumentType.self) " +
				"but received object \(argument) of type " +
			"\(type(of: argument))."
			throw EKError.invalidArgumentTypeError(message: message)
		}
	}
}

public struct EKMethodVoidAction<ObjectType, ReturnType>: EKAction {
	typealias Method = (ObjectType) -> () -> (ReturnType)

	let object: ObjectType
	let method: Method

	@discardableResult
	public func callWithArgument(_ argument: Any?) throws -> Any? {
		return method(object)()
	}
}

public struct EKMethodAction<ObjectType, ArgumentType, ReturnType>: EKAction {
	typealias Method = (ObjectType) -> (ArgumentType) -> (ReturnType)

	let object: ObjectType
	let method: Method

	@discardableResult
	public func callWithArgument(_ argument: Any?) throws -> Any? {
		if let typedArgument = argument as? ArgumentType {
			return method(object)(typedArgument)
		} else {
			let argument = argument ?? "nil"
			let message = "Expected argument of type \(ArgumentType.self) " +
				"but received object \(argument) of type " +
			"\(type(of: argument))."
			throw EKError.invalidArgumentTypeError(message: message)
		}
	}
}

public class EKEventCenter {
	var allActions = [String: [EKAction]]()

	public func fireEvent(_ event: EKEvent) {
		let className = eventName(forEvent: event)
		if let actions = allActions[className] {
			for action in actions {
				// swiftlint:disable:next force_try
				try! action.callWithArgument(event)
			}
		}

		if let superEvent = event.createSuperclassEvent() {
			fireEvent(superEvent)
		}
	}

	public func startSendingEvents(ofTypes types: [EKEvent.Type]) {
		for type in types {
			let className = eventName(forEventOfType: type.self)
			allActions[className] = [EKAction]()
		}
	}

	public func register<T>(
		forEventNamed name: String,
		target: T,
		method: @escaping(T) -> (EKEvent) -> Void) throws
	{
		do {
			let callback = EKMethodAction(object: target, method: method)
			let className = eventName(forExternalName: name)
			try register(forEventNamed: className, action: callback)
		} catch let error {
			throw error
		}
	}

	public func register<Event: EKEvent, T>(
		forEvent type: Event.Type,
		target: T,
		method: @escaping(T) -> (Event) -> Void) throws
	{
		do {
			let callback = EKMethodAction(object: target, method: method)
			let className = eventName(forEventOfType: type.self)
			try register(forEventNamed: className, action: callback)
		} catch let error {
			throw error
		}
	}

	public func register(forEventNamed name: String,
	                     callback: @escaping(EKEvent) -> Void) throws {
		do {
			let callback = EKFunctionAction(closure: callback)
			let className = eventName(forExternalName: name)
			try register(forEventNamed: className, action: callback)
		} catch let error {
			throw error
		}
	}

	public func register<Event: EKEvent>(
		forEvent type: Event.Type,
		callback: @escaping(Event) -> Void) throws
	{
		do {
			let callback = EKFunctionAction(closure: callback)
			let className = eventName(forEventOfType: type.self)
			try register(forEventNamed: className, action: callback)
		} catch let error {
			throw error
		}
	}

	func register(forEventNamed eventName: String,
	              action: EKAction) throws {
		if allActions[eventName] == nil {
			throw EKError.eventRegistryError(
				message: "No addons have been registered to fire " + eventName +
				" events")
		}

		allActions[eventName]?.append(action)
	}

	func eventName(forExternalName name: String) -> String {
		let capitalized = name.capitalizedString
		let components = capitalized.split(character: " ")
		let camelCase: String = components.reduce("", +)
		return "EKEvent" + camelCase
	}

	func eventName<Event: EKEvent>(forEventOfType type: Event.Type) -> String {
		return "\(type.self)"
	}

	func eventName<Event: EKEvent>(forEvent event: Event) -> String {
		return "\(type(of: event))"
	}
}

//
public class EKEvent: EKLanguageCompatible {
	public func createSuperclassEvent() -> EKEvent? {
		return nil
	}
}

//
public enum EKEventInputState: String, RawRepresentable, EKLanguageCompatible {
	case began
	case changed
	case ended
}

public class EKEventScreenInput: EKEvent {
	public let touches: Int
	public let position: EKVector2

	public init(position: EKVector2, touches: Int) {
		self.position = position
		self.touches = touches
	}
}

public class EKEventScreenInputContinuous: EKEventScreenInput {
	override public func createSuperclassEvent() -> EKEvent? {
		return EKEventScreenInput(position: position,
		                          touches: touches)
	}

	public let state: EKEventInputState

	public init(position: EKVector2,
	            touches: Int,
	            state: EKEventInputState) {
		self.state = state
		super.init(position: position, touches: touches)
	}
}

public class EKEventTap: EKEventScreenInput {
	override public func createSuperclassEvent() -> EKEvent? {
		return EKEventScreenInput(position: position,
		                          touches: touches)
	}
}

public class EKEventPan: EKEventScreenInputContinuous {
	override public func createSuperclassEvent() -> EKEvent? {
		return EKEventScreenInputContinuous(position: position,
		                                    touches: touches,
		                                    state: state)
	}

	public let displacement: EKVector2

	public init(position: EKVector2,
	            touches: Int,
	            displacement: EKVector2,
	            state: EKEventInputState) {
		self.displacement = displacement
		super.init(position: position, touches: touches, state: state)
	}
}

public class EKEventPinch: EKEventScreenInputContinuous {
	override public func createSuperclassEvent() -> EKEvent? {
		return EKEventScreenInputContinuous(position: position,
		                                    touches: touches,
		                                    state: state)
	}

	public let scale: Double

	public init(position: EKVector2,
	            touches: Int,
	            scale: Double,
	            state: EKEventInputState) {
		self.scale = scale
		super.init(position: position, touches: touches, state: state)
	}
}

public class EKEventRotation: EKEventScreenInputContinuous {
	override public func createSuperclassEvent() -> EKEvent? {
		return EKEventScreenInputContinuous(position: position,
		                                    touches: touches,
		                                    state: state)
	}

	public let angle: Double

	public init(position: EKVector2,
	            touches: Int,
	            angle: Double,
	            state: EKEventInputState) {
		self.angle = angle
		super.init(position: position, touches: touches, state: state)
	}
}

public class EKEventLongPress: EKEventScreenInputContinuous {
	override public func createSuperclassEvent() -> EKEvent? {
		return EKEventScreenInputContinuous(position: position,
		                                    touches: touches,
		                                    state: state)
	}

	public let displacement: EKVector2

	public init(position: EKVector2,
	            touches: Int,
	            displacement: EKVector2,
	            state: EKEventInputState) {
		self.displacement = displacement
		super.init(position: position, touches: touches, state: state)
	}
}
