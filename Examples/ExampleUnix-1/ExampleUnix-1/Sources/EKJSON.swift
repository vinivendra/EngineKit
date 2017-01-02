public enum EKCommand: String {
	case translate
	case rotate
	case scale
	case changeColor = "changecolor"
	case remove

	static func applyCommand(fromJSON JSONObject: Any) {
		guard let rootDictionary = JSONObject as? [String: Any],
			let actionString = rootDictionary["action"] as? String,
			let command = EKCommand(rawValue: actionString.lowercased()),
			let parameters = rootDictionary["parameters"] as? [String: Any]
			else {
				return
		}

		switch command {
		case .translate:
			applyTranslation(withParameters: parameters)
		case .rotate:
			EKCommandRotate.apply(withParameters: parameters)
		case .scale:
			EKCommandScale.apply(withParameters: parameters)
		case .changeColor:
			EKCommandChangeColor.apply(withParameters: parameters)
		case .remove:
			EKCommandRemove.apply(withParameters: parameters)
		}
	}

	static func getTargets(_ parameters: [String: Any]) -> [[Double]]? {
		return parameters["targets"] as? [[Double]]
	}

	static func getObject(_ parameters: [String: Any]) -> EKGLObject? {
		guard let objectID = parameters["id"] as? Int else { return nil }
		return EKGLObject.object(withID: objectID)
	}

	//
	// TODO: Refactor other commands just like translation
	static func applyTranslation(withParameters parameters: [String: Any]) {
		guard let targets = getTargets(parameters),
			let object = getObject(parameters)
			else {
				return
		}

		let animationTargets = targets.map(EKVector3.createVector(fromArray:))

		EKAnimationTranslate(
			duration: 1.0,
			chainValues: animationTargets,
			object: object
			)?.start()
	}
}

public struct EKCommandRotate {
	public static func apply(withParameters parameters: [String: Any]) {
		guard let targets = parameters["targets"] as? [[Double]],
			let objectID = parameters["id"] as? Int,
			let object = EKGLObject.object(withID: objectID)
			else {
				return
		}

		let animationTargets = targets.map(
			EKRotation.createRotation(fromArray:))

		let animation = EKAnimation(
			duration: 1.0,
			startValue: object.rotation,
			chainValues: animationTargets) {
				object.rotation = $0
		}

		animation?.start()
	}
}

public struct EKCommandScale {
	public static func apply(withParameters parameters: [String: Any]) {
		guard let targets = parameters["targets"] as? [[Double]],
			let objectID = parameters["id"] as? Int,
			let object = EKGLObject.object(withID: objectID)
			else {
				return
		}

		let animationTargets = targets.map(EKVector3.createVector(fromArray:))

		let animation = EKAnimation(
			duration: 1.0,
			startValue: object.scale,
			chainValues: animationTargets) {
				object.scale = $0
		}

		animation?.start()
	}
}

public struct EKCommandChangeColor {
	public static func apply(withParameters parameters: [String: Any]) {
		guard let targets = parameters["targets"] as? [[Double]],
			let objectID = parameters["id"] as? Int,
			let object = EKGLObject.object(withID: objectID)
			else {
				return
		}

		let animationTargets = targets.map(EKVector4.createVector(fromArray:))

		let animation = EKAnimation(
			duration: 1.0,
			startValue: object.color.toEKVector4(),
			chainValues: animationTargets) {
				object.color = $0
		}

		animation?.start()
	}
}

public struct EKCommandRemove {
	public static func apply(withParameters parameters: [String: Any]) {
		guard let objectID = parameters["id"] as? Int,
			let object = EKGLObject.object(withID: objectID)
			else {
				return
		}

		object.destroy()
	}
}
