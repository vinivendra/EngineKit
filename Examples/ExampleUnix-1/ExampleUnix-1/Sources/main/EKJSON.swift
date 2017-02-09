// LOCK: File generated by gyb, do not edit
public enum EKCommand: String {
    case translate
    case rotate
    case scale
    case changeColor
	case changeName
	case remove
	case add

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
		case .changeName:
			applyChangeName(withParameters: parameters)
		case .remove:
			applyRemove(withParameters: parameters)
		case .add:
			applyAdd(withParameters: parameters)
		}
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

		let animationTargets = targets.map(EKColor.init(fromArray:))

		EKAnimationChangeColor(
			duration: 1.0,
			chainValues: animationTargets,
			object: object
			)?.start()
	}

	static func applyChangeName(withParameters parameters: [String: Any]) {
		guard let newName = parameters["name"] as? String,
			let object = getObject(parameters)
			else {
				return
		}

		object.name = newName
	}

	static func applyRemove(withParameters parameters: [String: Any]) {
		guard let object = getObject(parameters)
			else {
				return
			}

			object.destroy()
	}

	@discardableResult
	static func applyAdd(withParameters parameters: [String: Any])
		-> EKGLObject?
	{
		guard let meshName = parameters["mesh"] as? String,
			let vertexComponent = EKGLVertexComponent.component(
				forGeometryNamed: meshName)
			else {
				return nil
			}
		let object = EKGLObject(vertexComponent: vertexComponent)

		if let position = parameters["position"] {
			let vector = EKVector3.createVector(
				fromObject: position as AnyObject)
			object.position = vector
		}
		if let scale = parameters["scale"] {
			let vector = EKVector3.createVector(
				fromObject: scale as AnyObject)
			object.scale = vector
		}
		if let rotation = parameters["rotation"] {
			let vector = EKRotation.createRotation(
				fromObject: rotation as AnyObject)
			object.rotation = vector
		}
		if let color = parameters["color"] {
			let vector = EKColor(fromValue: color)
			object.color = vector
		}
		if let name = parameters["name"] as? String {
			object.name = name
		}

		if let children = parameters["children"] as? [[String: Any]] {
			for child in children {
				let childObject = applyAdd(withParameters: child)
				if let childObject = childObject {
					object.addChild(childObject)
				}
			}
		}

		return object
	}

	//
	static func getTargets(_ parameters: [String: Any]) -> [[Double]]? {
		return parameters["targets"] as? [[Double]]
	}

	static func getObject(_ parameters: [String: Any]) -> EKGLObject? {
		guard let objectID = parameters["id"] as? Int else { return nil }
		return EKGLObject.object(withID: objectID)
	}
}

extension EKGLObject {
	public func exportToJSON() -> [String: Any] {
		var json = [String: Any]()
		if let vertexComponent = self.vertexComponent {
			json["mesh"] = vertexComponent.meshName
		}

		json["name"] = self.name

		json["color"] = self.color.toArray()

		json["position"] = self.position.toArray()
		json["scale"] = self.scale.toArray()
		json["rotation"] = self.rotation.toArray()

		if self.children.count > 0 {
			var childrenJSON = [[String: Any]]()

			for child in self.children {
				childrenJSON.append(child.exportToJSON())
			}

			json["children"] = childrenJSON
		}

		return json
	}
}
