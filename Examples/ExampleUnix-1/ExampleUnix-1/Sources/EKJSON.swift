// TODO: Refactor EKCommand.
// commands should be switched via enum; consider subclassing for DRY.

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
			EKCommandTranslate.apply(withParameters: parameters)
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
}

public struct EKCommandTranslate {
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
			startValue: object.position,
			chainValues: animationTargets) {
				object.position = $0
		}

		animation?.start()
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
