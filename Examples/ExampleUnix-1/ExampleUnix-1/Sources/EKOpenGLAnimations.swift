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

public class EKAnimationRotate: EKAnimation<EKRotation> {
	init(duration: Double,
	     endValue: EKRotation,
	     repeats: Bool = false,
	     autoreverses: Bool = false,
	     timingFunction: EKTimingFunction = .easeInOut,
	     object: EKGLObject) {
		super.init(duration: duration,
		           startValue: object.rotation,
		           endValue: endValue,
		           repeats: repeats,
		           autoreverses: autoreverses,
		           timingFunction: timingFunction,
		           action: {
					object.rotation = $0
		})
	}

	public init?(duration: Double,
	             chainValues: [EKRotation],
	             repeats: Bool = false,
	             autoreverses: Bool = false,
	             timingFunction: EKTimingFunction = .easeInOut,
	             object: EKGLObject) {
		super.init(duration: duration,
		           startValue: object.rotation,
		           chainValues: chainValues,
		           repeats: repeats,
		           autoreverses: autoreverses,
		           timingFunction: timingFunction,
		           action: {
					object.rotation = $0
		})
	}
}

public class EKAnimationScale: EKAnimation<EKVector3> {
	init(duration: Double,
	     endValue: EKVector3,
	     repeats: Bool = false,
	     autoreverses: Bool = false,
	     timingFunction: EKTimingFunction = .easeInOut,
	     object: EKGLObject) {
		super.init(duration: duration,
		           startValue: object.scale,
		           endValue: endValue,
		           repeats: repeats,
		           autoreverses: autoreverses,
		           timingFunction: timingFunction,
		           action: {
					object.scale = $0
		})
	}

	public init?(duration: Double,
	             chainValues: [EKVector3],
	             repeats: Bool = false,
	             autoreverses: Bool = false,
	             timingFunction: EKTimingFunction = .easeInOut,
	             object: EKGLObject) {
		super.init(duration: duration,
		           startValue: object.scale,
		           chainValues: chainValues,
		           repeats: repeats,
		           autoreverses: autoreverses,
		           timingFunction: timingFunction,
		           action: {
					object.scale = $0
		})
	}
}

public class EKAnimationChangeColor: EKAnimation<EKVector4> {
	init(duration: Double,
	     endValue: EKVector4,
	     repeats: Bool = false,
	     autoreverses: Bool = false,
	     timingFunction: EKTimingFunction = .easeInOut,
	     object: EKGLObject) {
		super.init(duration: duration,
		           startValue: object.color.toEKVector4(),
		           endValue: endValue,
		           repeats: repeats,
		           autoreverses: autoreverses,
		           timingFunction: timingFunction,
		           action: {
					object.color = $0
		})
	}

	public init?(duration: Double,
	             chainValues: [EKVector4],
	             repeats: Bool = false,
	             autoreverses: Bool = false,
	             timingFunction: EKTimingFunction = .easeInOut,
	             object: EKGLObject) {
		super.init(duration: duration,
		           startValue: object.color.toEKVector4(),
		           chainValues: chainValues,
		           repeats: repeats,
		           autoreverses: autoreverses,
		           timingFunction: timingFunction,
		           action: {
					object.color = $0
		})
	}
}
