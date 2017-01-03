public enum EKCommand: String {
    case translate
    case rotate
    case scale
    case changeColor
	case remove

	static func applyCommand(fromJSON JSONObject: Any) {
		guard let rootDictionary = JSONObject as? [String: Any],
			let actionString = rootDictionary["action"] as? String,
			let command = EKCommand(rawValue: actionString),
			let parameters = rootDictionary["parameters"] as? [String: Any]
			else {
				return
		}

		switch command {
		case .translate:
			applyTranslate(withParameters: parameters)
		case .rotate:
			applyRotate(withParameters: parameters)
		case .scale:
			applyScale(withParameters: parameters)
		case .changeColor:
			applyChangeColor(withParameters: parameters)
		case .remove:
			applyRemove(withParameters: parameters)
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
	static func applyTranslate(withParameters parameters: [String: Any]) {
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

	static func applyRotate(withParameters parameters: [String: Any]) {
		guard let targets = getTargets(parameters),
			let object = getObject(parameters)
			else {
				return
		}

		let animationTargets = targets.map(EKRotation.createRotation(fromArray:))

		EKAnimationRotate(
			duration: 1.0,
			chainValues: animationTargets,
			object: object
			)?.start()
	}

	static func applyScale(withParameters parameters: [String: Any]) {
		guard let targets = getTargets(parameters),
			let object = getObject(parameters)
			else {
				return
		}

		let animationTargets = targets.map(EKVector3.createVector(fromArray:))

		EKAnimationScale(
			duration: 1.0,
			chainValues: animationTargets,
			object: object
			)?.start()
	}

	static func applyChangeColor(withParameters parameters: [String: Any]) {
		guard let targets = getTargets(parameters),
			let object = getObject(parameters)
			else {
				return
		}

		let animationTargets = targets.map(EKVector4.createVector(fromArray:))

		EKAnimationChangeColor(
			duration: 1.0,
			chainValues: animationTargets,
			object: object
			)?.start()
	}

	static func applyRemove(withParameters parameters: [String: Any]) {
		guard let object = getObject(parameters)
			else {
				return
		}

		object.destroy()
	}
}
