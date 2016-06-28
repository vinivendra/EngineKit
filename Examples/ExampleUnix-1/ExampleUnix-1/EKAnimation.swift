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

var EKAnimationPool = EKResourcePool<Any>()

public final class EKAnimation
	<InterpolatedType: Interpolable>: EKTimerDelegate {

	private var poolIndex: Int? = nil

	private let timer: EKTimer
	private let action: EKAction

	public let duration: Double
	public let startValue: InterpolatedType
	public let endValue: InterpolatedType

	//
	public init(duration: Double,
	            startValue: InterpolatedType,
	            endValue: InterpolatedType,
	            action: (InterpolatedType) -> ()) {
		self.duration = duration
		self.startValue = startValue
		self.endValue = endValue
		self.action = EKFunctionAction(closure: action)
		self.timer = EKTimer(duration: duration)
		timer.delegate = self
	}

	public func start() {
		if poolIndex == nil {
			poolIndex = EKAnimationPool.addResourceAndGetIndex(self)
		}
		timer.start()
	}

	public func timerHasUpdated(timer: EKTimer,
	                     currentTime: Double,
	                     deltaTime: Double) {
		do {
			try action.callWithArgument(InterpolatedType.interpolate(
				start: startValue,
				end: endValue,
				interpolatedValue: currentTime / duration))
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

	}
}