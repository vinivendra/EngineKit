public protocol Interpolable {
	static func interpolate(start start: Self,
	                        end: Self,
	                        interpolatedValue: Double) -> Self
}

extension Double: Interpolable {
	public static func interpolate(start start: Double,
	                               end: Double,
	                               interpolatedValue: Double) -> Double {
		return start + (end - start) * interpolatedValue
	}
}

private var EKAnimationPool = EKResourcePool<Any>()

public final class EKAnimation
	<InterpolatedType: Interpolable>: EKTimerDelegate {

	private var poolIndex: Int? = nil

	private let timer: EKTimer
	private let action: EKAction

	public let duration: Double
	public let startValue: InterpolatedType
	public let endValue: InterpolatedType
	public let repeats: Bool
	public let autoreverses: Bool

	private var isReversed = false

	//
	public init(duration: Double,
	            startValue: InterpolatedType,
	            endValue: InterpolatedType,
	            repeats: Bool = false,
	            autoreverses: Bool = false,
	            action: (InterpolatedType) -> ()) {
		self.duration = duration
		self.startValue = startValue
		self.endValue = endValue
		self.repeats = repeats
		self.autoreverses = autoreverses
		self.action = EKFunctionAction(closure: action)
		self.timer = EKTimer(duration: duration, repeats: repeats)
		timer.delegate = self
	}

	public func start() {
		if poolIndex == nil {
			poolIndex = EKAnimationPool.addResourceAndGetIndex(self)
		}
		timer.start()
	}

	public func stop() {
		if let poolIndex = poolIndex {
			EKAnimationPool.deleteResource(atIndex: poolIndex)
		}
		timer.invalidate()
	}

	public func timerHasUpdated(timer: EKTimer,
	                     currentTime: Double,
	                     deltaTime: Double) {
		do {
			let interpolatedValue = currentTime / duration
			let animationValue = isReversed ?
				interpolatedValue :
				1.0 - interpolatedValue
			try action.callWithArgument(InterpolatedType.interpolate(
				start: startValue,
				end: endValue,
				interpolatedValue: animationValue))
		} catch {
			assertionFailure()
		}
	}

	public func timerHasFinished(timer: EKTimer) {
		if let poolIndex = poolIndex {
			EKAnimationPool.deleteResource(atIndex: poolIndex)
		}
	}

	public func timerWillRepeat(timer: EKTimer) {
		if autoreverses {
			isReversed = !isReversed
		}
	}
}