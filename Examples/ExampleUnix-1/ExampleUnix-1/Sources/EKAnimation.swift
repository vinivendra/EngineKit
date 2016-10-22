public protocol Interpolable {
	static func interpolate(start: Self,
	                        end: Self,
	                        interpolatedValue: Double) -> Self
}

extension Double: Interpolable {
	public static func interpolate(start: Double,
	                               end: Double,
	                               interpolatedValue: Double) -> Double {
		return start + (end - start) * interpolatedValue
	}
}

extension Float: Interpolable {
	public static func interpolate(start: Float,
	                               end: Float,
	                               interpolatedValue: Double) -> Float {
		return start + (end - start) * Float(interpolatedValue)
	}
}

extension EKVector2: Interpolable {
	public static func interpolate(start: EKVector2,
	                               end: EKVector2,
	                               interpolatedValue: Double) -> EKVector2 {
		return start.plus( ( end.minus(start) ).times(interpolatedValue) )
	}
}

extension EKVector3: Interpolable {
	public static func interpolate(start: EKVector3,
	                               end: EKVector3,
	                               interpolatedValue: Double) -> EKVector3 {
		return start.plus( ( end.minus(start) ).times(interpolatedValue) )
	}
}

extension EKVector4: Interpolable {
	public static func interpolate(start: EKVector4,
	                               end: EKVector4,
	                               interpolatedValue: Double) -> EKVector4 {
		return start.plus( ( end.minus(start) ).times(interpolatedValue) )
	}
}

//
public typealias EKInterpolationFunction = (Double) -> Double

public enum EKTimingFunction {
	case Linear
	case EaseIn
	case EaseOut
	case EaseInOut
	case Other(EKInterpolationFunction)

	// swiftlint:disable variable_name
	private static let linear = { (x: Double) -> Double in
		return x
	}

	private static let easeInOut = { (x: Double) -> Double in
		return (x * x * x * (x * (x * 6 - 15) + 10))
	}

	private static let easeIn = { (x: Double) -> Double in
		return x * x
	}

	private static let easeOut = { (x: Double) -> Double in
		return 1 - ((1 - x) * (1 - x))
	}
	// swiftlint:enable variable_name

	public func getFunction() -> (EKInterpolationFunction) {
		switch self {
		case .Linear:
			return EKTimingFunction.linear
		case .EaseIn:
			return EKTimingFunction.easeIn
		case .EaseOut:
			return EKTimingFunction.easeOut
		case .EaseInOut:
			return EKTimingFunction.easeInOut
		case .Other(let function):
			return function
		}
	}
}

//
private var EKAnimationPool = EKResourcePool<Any>()

public final class EKAnimation
<InterpolatedType: Interpolable>: EKTimerDelegate {

	private var poolIndex: Int? = nil

	private var isReversed = false
	private let timer: EKTimer
	private let action: EKAction
	private let timingFunction: EKInterpolationFunction

	public let duration: Double
	public private(set) var startValue: InterpolatedType
	public let endValue: InterpolatedType
	public let repeats: Bool
	public let autoreverses: Bool

	public var chainAnimation: EKAnimation<InterpolatedType>?

	//
	public init(duration: Double,
	            startValue: InterpolatedType,
	            endValue: InterpolatedType,
	            repeats: Bool = false,
	            autoreverses: Bool = false,
	            timingFunction: EKTimingFunction = .EaseInOut,
	            action: @escaping((InterpolatedType) -> ())) {
		self.duration = duration
		self.startValue = startValue
		self.endValue = endValue
		self.repeats = repeats
		self.autoreverses = autoreverses
		self.timingFunction = timingFunction.getFunction()
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

	public func timerHasUpdated(_ timer: EKTimer,
	                            currentTime: Double,
	                            deltaTime: Double) {
		do {
			let interpolatedValue = currentTime / duration
			let reversedValue = isReversed ?
				1.0 - interpolatedValue :
			interpolatedValue
			let animationValue = timingFunction(reversedValue)
			try action.callWithArgument(InterpolatedType.interpolate(
				start: startValue,
				end: endValue,
				interpolatedValue: animationValue))
		} catch {
			assertionFailure()
		}
	}

	public func timerHasFinished(_ timer: EKTimer) {
		if let poolIndex = poolIndex {
			EKAnimationPool.deleteResource(atIndex: poolIndex)
		}
		chain()
	}

	public func timerWillRepeat(_ timer: EKTimer) {
		if autoreverses {
			isReversed = !isReversed
		}
	}

	@discardableResult
	func chain() {
		guard let chainAnimation = chainAnimation else { return }
		chainAnimation.startValue = self.endValue
		chainAnimation.start()
	}
}
