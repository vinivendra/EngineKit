#if os(Linux)
	import Glibc
#else
	import Darwin
#endif

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

extension EKRotation: Interpolable {
	public static func interpolate(
		start: EKRotation,
		end: EKRotation,
		interpolatedValue ratio: Double) -> EKRotation
	{
		let cosHalfAngle =
			start.x * end.x +
			start.y * end.y +
			start.z * end.z +
			start.w * end.w

		let angleIsNotZero = ( abs(cosHalfAngle) < 1.0 )
		guard angleIsNotZero else {
			return start
		}

		let halfAngle = acos(cosHalfAngle)
		let sinHalfAngle = sqrt(1.0 - cosHalfAngle * cosHalfAngle)

		let ratioStart = sin((1 - ratio) * halfAngle) / sinHalfAngle
		let ratioEnd = sin(ratio * halfAngle) / sinHalfAngle

		return EKRotation(x: start.x * ratioStart + end.x * ratioEnd,
		                  y: start.y * ratioStart + end.y * ratioEnd,
		                  z: start.z * ratioStart + end.z * ratioEnd,
		                  w: start.w * ratioStart + end.w * ratioEnd)
	}
}

extension EKColor: Interpolable {
	public static func interpolate(start startColor: EKColor,
	                               end endColor: EKColor,
	                               interpolatedValue: Double) -> EKColor {
		let start = startColor.toEKVector4()
		let end = endColor.toEKVector4()
		let result =
			start.plus( ( end.minus(start) ).times(interpolatedValue) )
		return EKColor(copying: result)
	}
}

//
public typealias EKInterpolationFunction = (Double) -> Double

public enum EKTimingFunction {
	case linear
	case easeIn
	case easeOut
	case easeInOut
	case other(EKInterpolationFunction)

	// swiftlint:disable variable_name
	private static let linearFunction = { (x: Double) -> Double in
		return x
	}

	private static let easeInOutFunction = { (x: Double) -> Double in
		return (x * x * x * (x * (x * 6 - 15) + 10))
	}

	private static let easeInFunction = { (x: Double) -> Double in
		return x * x
	}

	private static let easeOutFunction = { (x: Double) -> Double in
		return 1 - ((1 - x) * (1 - x))
	}
	// swiftlint:enable variable_name

	public func getFunction() -> (EKInterpolationFunction) {
		switch self {
		case .linear:
			return EKTimingFunction.linearFunction
		case .easeIn:
			return EKTimingFunction.easeInFunction
		case .easeOut:
			return EKTimingFunction.easeOutFunction
		case .easeInOut:
			return EKTimingFunction.easeInOutFunction
		case .other(let function):
			return function
		}
	}
}

//
private var EKAnimationPool = EKResourcePool<Any>()

public class EKAnimation
<InterpolatedType: Interpolable>: EKTimerDelegate {

	private var poolIndex: Int?

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
	            timingFunction: EKTimingFunction = .easeInOut,
	            action: @escaping((InterpolatedType) -> Void)) {
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

	public init?(duration: Double,
	             startValue: InterpolatedType,
	             chainValues: [InterpolatedType],
	             repeats: Bool = false,
	             autoreverses: Bool = false,
	             timingFunction: EKTimingFunction = .easeInOut,
	             action: @escaping((InterpolatedType) -> Void)) {
		guard let firstChainValue = chainValues.first
			else { return nil }

		self.duration = duration
		self.startValue = startValue
		self.endValue = firstChainValue
		self.repeats = repeats
		self.autoreverses = autoreverses
		self.timingFunction = timingFunction.getFunction()
		self.action = EKFunctionAction(closure: action)
		self.timer = EKTimer(duration: duration, repeats: repeats)
		timer.delegate = self

		let chainAnimation = EKAnimation(
			duration: duration,
			chainValues: ArraySlice<InterpolatedType>(chainValues),
			repeats: repeats,
			autoreverses: autoreverses,
			timingFunction: timingFunction,
			action: action)

		self.chainAnimation = chainAnimation
	}

	convenience init?(duration: Double,
	                  chainValues: ArraySlice<InterpolatedType>,
	                  repeats: Bool = false,
	                  autoreverses: Bool = false,
	                  timingFunction: EKTimingFunction = .easeInOut,
	                  action: @escaping((InterpolatedType) -> Void)) {
		let otherChainValues = chainValues.dropFirst()

		guard let start = chainValues.first,
			let end = otherChainValues.first
			else {
				return nil
		}

		self.init(
			duration: duration,
			startValue: start,
			endValue: end,
			repeats: repeats,
			autoreverses: autoreverses,
			timingFunction: timingFunction,
			action: action)

		let chainAnimation = EKAnimation(
			duration: duration,
			chainValues: otherChainValues,
			repeats: repeats,
			autoreverses: autoreverses,
			timingFunction: timingFunction,
			action: action)

		self.chainAnimation = chainAnimation
	}

	//
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
				1.0 - interpolatedValue : interpolatedValue
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

	func chain() {
		guard let chainAnimation = chainAnimation else { return }
		chainAnimation.startValue = self.endValue
		chainAnimation.start()
	}
}
