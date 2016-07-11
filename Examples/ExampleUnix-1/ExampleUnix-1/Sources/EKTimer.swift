public final class EKTimer {
	private static var pool = EKResourcePool<EKTimer>()
	private var poolIndex: Int? = nil

	private let argument: Any?
	private let action: EKAction?

	private var elapsedTime: Double = 0
	private let duration: Double
	private let repeats: Bool

	public weak var delegate: EKTimerDelegate? = nil

	//
	public static func updateTimers(deltaTime dt: Double) {
		for timer in pool {
			timer.update(deltaTime: dt)
		}
	}

	//
	public init(duration: Double,
	            repeats: Bool = false) {
		self.argument = nil
		self.action = nil
		self.duration = duration
		self.repeats = repeats
	}

	public init(duration: Double,
	            repeats: Bool = false,
	            action: () -> ()) {
		self.argument = nil
		self.action = EKFunctionVoidAction(closure: action)
		self.duration = duration
		self.repeats = repeats
	}

	public init<Argument>(duration: Double,
	            repeats: Bool = false,
	            argument: Argument,
	            action: (Argument) -> ()) {
		self.argument = argument
		self.action = EKFunctionAction(closure: action)
		self.duration = duration
		self.repeats = repeats
	}

	public init<Argument, Target>(duration: Double,
	            repeats: Bool = false,
	            argument: Argument,
	            target: Target,
	            action: (Target) -> (Argument) -> ()) {
		self.argument = argument
		self.action = EKMethodAction(object: target, method: action)
		self.duration = duration
		self.repeats = repeats
	}

	public init<Target>(duration: Double,
	            repeats: Bool = false,
	            target: Target,
	            action: (Target) -> () -> ()) {
		self.argument = nil
		self.action = EKMethodVoidAction(object: target, method: action)
		self.duration = duration
		self.repeats = repeats
	}

	//
	public func start() {
		if poolIndex == nil {
			poolIndex = EKTimer.pool.addResourceAndGetIndex(self)
		}
	}

	public func reset() {
		elapsedTime = 0
	}

	public func invalidate() {
		if let poolIndex = poolIndex {
			EKTimer.pool.deleteResource(atIndex: poolIndex)
		}

		delegate?.timerHasFinished(self)
	}
}

extension EKTimer {
	private func update(deltaTime dt: Double) {
		elapsedTime = elapsedTime + dt
		if elapsedTime < duration {
			delegate?.timerHasUpdated(self,
			                         currentTime: elapsedTime,
			                         deltaTime: dt)
		} else {
			delegate?.timerHasUpdated(self,
			                         currentTime: duration,
			                         deltaTime: dt)

			do {
				_ = try action?.callWithArgument(argument)
			} catch {
				assertionFailure()
			}

			if repeats {
				elapsedTime = elapsedTime - duration
				delegate?.timerWillRepeat(self)
			} else {
				self.invalidate()
			}
		}
	}
}

public protocol EKTimerDelegate: class {
	func timerHasUpdated(_ timer: EKTimer,
	                     currentTime: Double,
	                     deltaTime: Double)

	func timerHasFinished(_ timer: EKTimer)

	func timerWillRepeat(_ timer: EKTimer)
}
