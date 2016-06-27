public final class EKTimer {
	private static var pool = EKResourcePool<EKTimer>()
	private var poolIndex: Int = 0

	private let argument: Any?
	private let action: EKAction

	private var elapsedTime: Double = 0
	private let duration: Double
	private let repeats: Bool

	public init(duration: Double,
	            repeats: Bool = false,
	            action: () -> ()) {
		self.argument = nil
		self.action = EKFunctionVoidAction(closure: action)
		self.duration = duration
		self.repeats = repeats
		self.poolIndex = EKTimer.pool.addResourceAndGetIndex(self)
	}

	public init<Argument>(duration: Double,
	            repeats: Bool = false,
	            argument: Argument,
	            action: (Argument) -> ()) {
		self.argument = argument
		self.action = EKFunctionAction(closure: action)
		self.duration = duration
		self.repeats = repeats
		self.poolIndex = EKTimer.pool.addResourceAndGetIndex(self)
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
		self.poolIndex = EKTimer.pool.addResourceAndGetIndex(self)
	}

	public static func updateTimers(deltaTime dt: Double) {
		for timer in pool {
			timer.update(deltaTime: dt)
		}
	}

	private func update(deltaTime dt: Double) {
		elapsedTime = elapsedTime + dt
		if elapsedTime > duration {
			do {
				try action.callWithArgument(argument)
			} catch {
				assertionFailure()
			}

			if repeats {
				elapsedTime = elapsedTime - duration
			} else {
				EKTimer.pool.deleteResource(atIndex: poolIndex)
			}
		}
	}
}
