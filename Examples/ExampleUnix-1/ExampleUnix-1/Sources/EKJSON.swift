// swiftlint:disable force_try

public protocol EKCommand {
	// swiftlint:disable:next variable_name
	func apply()
}

public struct EKCommandTranslate: EKCommand {
	let targets: [[Double]]
	let objectID: Int

	public func apply() {
		guard let target = targets.first,
			let object = EKGLObject.object(withID: objectID)
			else { return }

		let firstAnimation = EKAnimation(
			duration: 1.0,
			startValue: object.position,
			endValue: EKVector3.createVector(fromArray: target)) {
				object.position = $0
		}

		var latestAnimation = firstAnimation
		for target in targets.dropFirst() {
			let newAnimation = EKAnimation(
				duration: 1.0,
				startValue: object.position,
				endValue: EKVector3.createVector(fromArray: target)) {
					object.position = $0
			}
			latestAnimation.chainAnimation = newAnimation
			latestAnimation = newAnimation
		}

		firstAnimation.start()
	}
}

public struct EKCommandRotate: EKCommand {
	let targets: [[Double]]
	let objectID: Int

	public func apply() {
		guard let target = targets.first,
			let object = EKGLObject.object(withID: objectID)
			else { return }

		let firstAnimation = EKAnimation(
			duration: 1.0,
			startValue: object.rotation,
			endValue: EKRotation.createRotation(fromArray: target)) {
				object.rotation = $0
		}

		var latestAnimation = firstAnimation
		for target in targets.dropFirst() {
			let newAnimation = EKAnimation(
				duration: 1.0,
				startValue: object.rotation,
				endValue: EKRotation.createRotation(fromArray: target)) {
					object.rotation = $0
			}
			latestAnimation.chainAnimation = newAnimation
			latestAnimation = newAnimation
		}

		firstAnimation.start()
	}
}

public struct EKCommandScale: EKCommand {
	let targets: [[Double]]
	let objectID: Int

	public func apply() {
		guard let target = targets.first,
			let object = EKGLObject.object(withID: objectID)
			else { return }

		let firstAnimation = EKAnimation(
			duration: 1.0,
			startValue: object.scale,
			endValue: EKVector3.createVector(fromArray: target)) {
				object.scale = $0
		}

		var latestAnimation = firstAnimation
		for target in targets.dropFirst() {
			let newAnimation = EKAnimation(
				duration: 1.0,
				startValue: object.scale,
				endValue: EKVector3.createVector(fromArray: target)) {
					object.scale = $0
			}
			latestAnimation.chainAnimation = newAnimation
			latestAnimation = newAnimation
		}

		firstAnimation.start()
	}
}

public struct EKCommandChangeColor: EKCommand {
	let targets: [[Double]]
	let objectID: Int

	public func apply() {
		guard let target = targets.first,
			let object = EKGLObject.object(withID: objectID)
			else { return }

		let firstAnimation = EKAnimation(
			duration: 1.0,
			startValue: object.color.toEKVector4(),
			endValue: EKVector4.createVector(fromArray: target)) {
				object.color = $0
		}

		var latestAnimation = firstAnimation
		for target in targets.dropFirst() {
			let newAnimation = EKAnimation(
				duration: 1.0,
				startValue: object.color.toEKVector4(),
				endValue: EKVector4.createVector(fromArray: target)) {
					object.color = $0
			}
			latestAnimation.chainAnimation = newAnimation
			latestAnimation = newAnimation
		}

		firstAnimation.start()
	}
}

public struct EKCommandRemove: EKCommand {
	let objectID: Int

	public func apply() {
		guard let object = EKGLObject.object(withID: objectID)
			else { return }

		object.destroy()
	}
}

// swiftlint:disable:next cyclomatic_complexity
func EKCommandCreate(fromJSON JSONObject: Any) -> EKCommand? {
	guard let rootDictionary = JSONObject as? [String: Any],
		let actionString = rootDictionary["action"] as? String,
		let parameters = rootDictionary["parameters"] as? [String: Any],
		let objectID = parameters["id"] as? Int
		else {
			return nil
	}

	switch actionString.lowercased() {
	case "translate":
		guard let targets = parameters["targets"] as? [[Double]]
			else { return nil }
		return EKCommandTranslate(targets: targets, objectID: objectID)
	case "rotate":
		guard let targets = parameters["targets"] as? [[Double]]
			else { return nil }
		return EKCommandRotate(targets: targets, objectID: objectID)
	case "scale":
		guard let targets = parameters["targets"] as? [[Double]]
			else { return nil }
		return EKCommandScale(targets: targets, objectID: objectID)
	case "changecolor":
		guard let targets = parameters["targets"] as? [[Double]]
			else { return nil }
		return EKCommandChangeColor(targets: targets, objectID: objectID)
	case "remove":
		return EKCommandRemove(objectID: objectID)
	default:
		return nil
	}
}
