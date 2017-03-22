public final class EKTimer {
	private static var pool = EKResourcePool<EKTimer>()
	private var poolIndex: Int?

	fileprivate let argument: Any?
	fileprivate let action: EKAction?

	fileprivate var elapsedTime: Double = 0
	fileprivate let duration: Double
	fileprivate let repeats: Bool

	public weak var delegate: EKTimerDelegate?

	//
	public static func updateTimers(deltaTime: Double) {
		for timer in pool {
			timer.update(deltaTime: deltaTime)
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
	            action: @escaping() -> Void) {
		self.argument = nil
		self.action = EKFunctionVoidAction(closure: action)
		self.duration = duration
		self.repeats = repeats
	}

	public init<Argument>(
		duration: Double,
		repeats: Bool = false,
		argument: Argument,
		action: @escaping(Argument) -> Void)
	{
		self.argument = argument
		self.action = EKFunctionAction(closure: action)
		self.duration = duration
		self.repeats = repeats
	}

	public init<Argument, Target>(
		duration: Double,
		repeats: Bool = false,
		argument: Argument,
		target: Target,
		action: @escaping(Target) -> (Argument) -> Void)
	{
		self.argument = argument
		self.action = EKMethodAction(object: target, method: action)
		self.duration = duration
		self.repeats = repeats
	}

	public init<Target>(
		duration: Double,
		repeats: Bool = false,
		target: Target,
		action: @escaping(Target) -> () -> Void)
	{
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
	fileprivate func update(deltaTime: Double) {
		elapsedTime += deltaTime

		delegate?.timerHasUpdated(self,
		                          currentTime: elapsedTime,
		                          deltaTime: deltaTime)

		while elapsedTime >= duration {
			do {
				_ = try action?.callWithArgument(argument)
			} catch {
				assertionFailure()
			}

			if repeats {
				elapsedTime -= duration
				delegate?.timerWillRepeat(self)
			} else {
				self.invalidate()
				return
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
