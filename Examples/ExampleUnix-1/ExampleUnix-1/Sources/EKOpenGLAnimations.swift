public class EKAnimationTranslate: EKAnimation<EKVector3> {
	init(duration: Double,
	     endValue: EKVector3,
	     repeats: Bool = false,
	     autoreverses: Bool = false,
	     timingFunction: EKTimingFunction = .easeInOut,
	     object: EKGLObject) {
		super.init(duration: duration,
		           startValue: object.position,
		           endValue: endValue,
		           repeats: repeats,
		           autoreverses: autoreverses,
		           timingFunction: timingFunction,
		           action: {
					object.position = $0
		})
	}

	public init?(duration: Double,
	             chainValues: [EKVector3],
	             repeats: Bool = false,
	             autoreverses: Bool = false,
	             timingFunction: EKTimingFunction = .easeInOut,
	             object: EKGLObject) {
		super.init(duration: duration,
		           startValue: object.position,
		           chainValues: chainValues,
		           repeats: repeats,
		           autoreverses: autoreverses,
		           timingFunction: timingFunction,
		           action: {
					object.position = $0
		})
	}
}
