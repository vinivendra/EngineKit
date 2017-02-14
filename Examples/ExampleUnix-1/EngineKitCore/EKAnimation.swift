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
	// swiftlint:disable variable_name
	public static func interpolate(start a: EKRotation,
	                               end b: EKRotation,
	                               interpolatedValue t: Double) -> EKRotation {
		let cosHalfAngle = a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w

		// if a=b or a=-b then angle=0 and we can return a
		if abs(cosHalfAngle) >= 1.0 {
			return a
		}

		let halfAngle = acos(cosHalfAngle)
		let sinHalfAngle = sqrt(1.0 - cosHalfAngle * cosHalfAngle)

		// if theta = 180 degrees then result is not fully defined
		// we could rotate around any axis normal to a or b
		// FIXME: not sure if this really is interpolated, it's independent in t
		if abs(sinHalfAngle) < 0.001 {
			return EKRotation(x: a.x/2 + b.x/2,
			                  y: a.y/2 + b.y/2,
			                  z: a.z/2 + b.z/2,
			                  w: a.w/2 + b.w/2)
		}

		let ratioA = sin((1 - t) * halfAngle) / sinHalfAngle
		let ratioB = sin(t * halfAngle) / sinHalfAngle

		return EKRotation(x: a.x * ratioA + b.x * ratioB,
		                  y: a.y * ratioA + b.y * ratioB,
		                  z: a.z * ratioA + b.z * ratioB,
		                  w: a.w * ratioA + b.w * ratioB)
	}
	// swiftlint:enable variable_name
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
