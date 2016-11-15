// swiftlint:disable force_try

public protocol EKCommand {
	// swiftlint:disable:next variable_name
	func apply(to: EKGLObject)
}

public struct EKCommandTranslate: EKCommand {
	let targets: [[Double]]

	public func apply(to object: EKGLObject) {
		guard let target = targets.first else { return }
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

	public func apply(to object: EKGLObject) {
		guard let target = targets.first else { return }
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

	public func apply(to object: EKGLObject) {
		guard let target = targets.first else { return }

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

	public func apply(to object: EKGLObject) {
		guard let target = targets.first else { return }

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

func EKCommandCreate(fromJSON JSONObject: Any) -> EKCommand? {
	guard let rootDictionary = JSONObject as? [String: Any],
		let actionString = rootDictionary["action"] as? String,
		let parameters = rootDictionary["parameters"] as? [String: Any]
		else { return nil }

	switch actionString.lowercased() {
	case "translate":
		guard let targets = parameters["targets"] as? [[Double]]
			else { return nil }
		return EKCommandTranslate(targets: targets)
	case "rotate":
		guard let targets = parameters["targets"] as? [[Double]]
			else { return nil }
		return EKCommandRotate(targets: targets)
	case "scale":
		guard let targets = parameters["targets"] as? [[Double]]
			else { return nil }
		return EKCommandScale(targets: targets)
	case "changecolor":
		guard let targets = parameters["targets"] as? [[Double]]
			else { return nil }
		return EKCommandChangeColor(targets: targets)
	default:
		return nil
	}
}
