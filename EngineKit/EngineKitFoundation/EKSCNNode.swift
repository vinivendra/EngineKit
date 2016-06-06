import SceneKit

@objc protocol NodeExport: JSExport {
	var position: AnyObject { get set }
	var scale: AnyObject { get set }
	var rotation: AnyObject { get set }
	func rotate(rotation: AnyObject)
	func rotate(rotation: AnyObject, around anchorPoint: AnyObject)
}

public class EKNode: NSObject, NodeExport {
	let node: SCNNode

	init(node: SCNNode? = nil) {
		self.node = node ?? SCNNode()
	}

	var position: AnyObject {
		get {
			return EKVector3.createVector(SCNVector3: node.position)
		}
		set {
			let vector = EKVector3.createVector(object: newValue)
			node.position = vector.toSCNVector3()
		}
	}

	var scale: AnyObject {
		get {
			return EKVector3.createVector(SCNVector3: node.scale)
		}
		set {
			let vector = EKVector3.createVector(object: newValue)
			node.scale = vector.toSCNVector3()
		}
	}

	var rotation: AnyObject {
		get {
			return EKVector4.createVector(SCNVector4: node.rotation)
		}
		set {
			let vector = EKVector4.createVector(object: newValue)
			node.rotation = vector.toSCNVector4()
		}
	}

	func rotate(rotation: AnyObject, around anchorPoint: AnyObject) {
		// TODO: This doesn't rotate around the anchor
		let position = EKVector3.createVector(SCNVector3: node.position)
		let orientation = EKVector4.createVector(SCNVector4: node.orientation)

		let rotation = EKVector4.createVector(object: rotation)
		let quaternion = rotation.rotationToQuaternion().unitQuaternion()

		let newPosition = quaternion.conjugate(vector: position)
		let newOrientation = quaternion.multiplyAsQuaternion(
			quaternion: orientation)

		node.position = newPosition.toSCNVector3()
		node.orientation = newOrientation.toSCNVector4()
	}

	func rotate(rotation: AnyObject) {
		let orientation = EKVector4.createVector(SCNVector4: node.orientation)

		let rotation = EKVector4.createVector(object: rotation)
		let quaternion = rotation.rotationToQuaternion().unitQuaternion()

		let newOrientation = quaternion.multiplyAsQuaternion(
			quaternion: orientation)

		node.orientation = newOrientation.toSCNVector4()
	}
}

//
public class EKCamera: EKNode, CameraExport, Scriptable {
	let camera = SCNCamera()

	override init(node: SCNNode? = nil) {
		super.init(node: node)
		self.node.camera = self.camera
	}
}

@objc protocol CameraExport: JSExport {
	var position: AnyObject { get set }
	var scale: AnyObject { get set }
	var rotation: AnyObject { get set }
	func rotate(rotation: AnyObject)
	func rotate(rotation: AnyObject, around anchorPoint: AnyObject)
}

//
public class EKShape: EKNode {
	var color: AnyObject {
		get {
			let contents = node.geometry?.materials.first?.ambient.contents
			if let contents = contents {
				return OSColor.createColor(object: contents)
			}

			return OSColor.whiteColor()
		}
		set {
			let color = OSColor.createColor(object: newValue)
			let material = SCNMaterial()

			let colorObject = color

			material.ambient.contents = colorObject
			material.diffuse.contents = colorObject
			material.specular.contents = colorObject
			node.geometry?.materials = [material]
		}
	}

	var physics: String {
		get {
			let type = node.physicsBody?.type

			switch type {
			case .Some(.Dynamic):
				return "dynamic"
			case .Some(.Kinematic):
				return "kinematic"
			case .Some(.Static):
				return "static"
			default:
				return "none"
			}
		}
		set {
			let type: SCNPhysicsBodyType?
			switch newValue.lowercaseString {
			case "dynamic":
				type = .Dynamic
			case "kinematic":
				type = .Kinematic
			case "static":
				type = .Static
			default:
				type = nil
			}

			if let type = type {
				let shape = SCNPhysicsShape(node: node, options: nil)
				node.physicsBody = SCNPhysicsBody(type: type, shape: shape)
			} else {
				node.physicsBody = nil
			}
		}
	}

	var velocity: AnyObject {
		get {
			if let velocity = node.physicsBody?.velocity {
				return EKVector3.createVector(SCNVector3: velocity)
			}
			return EKVector3.origin()
		}
		set {
			let vector = EKVector3.createVector(object: newValue)
			node.physicsBody?.velocity = vector.toSCNVector3()
		}
	}
}

//
public class EKSphere: EKShape, SphereExport, Scriptable {
	public required init() {
		super.init()
		node.geometry = SCNSphere()
	}

	var sphere: SCNSphere {
		get {
			return node.geometry as! SCNSphere
		}
	}

	var radius: CGFloat {
		get {
			return sphere.radius
		}
		set {
			sphere.radius = newValue
		}
	}
}

@objc protocol SphereExport: JSExport {
	var radius: CGFloat { get set }
	var position: AnyObject { get set }
	var scale: AnyObject { get set }
	var rotation: AnyObject { get set }
	var velocity: AnyObject { get set }
	var color: AnyObject { get set }
	var physics: String { get set }
	func rotate(rotation: AnyObject)
	func rotate(rotation: AnyObject, around anchorPoint: AnyObject)
}

//
public class EKBox: EKShape, BoxExport, Scriptable {
	required public init() {
		super.init()
		node.geometry = SCNBox()
	}

	var box: SCNBox {
		get {
			return node.geometry as! SCNBox
		}
	}

	var width: CGFloat {
		get {
			return box.width
		}
		set {
			box.width = newValue
		}
	}

	var length: CGFloat {
		get {
			return box.length
		}
		set {
			box.length = newValue
		}
	}

	var height: CGFloat {
		get {
			return box.height
		}
		set {
			box.height = newValue
		}
	}
}

@objc protocol BoxExport: JSExport {
	var width: CGFloat { get set }
	var length: CGFloat { get set }
	var height: CGFloat { get set }
	var position: AnyObject { get set }
	var scale: AnyObject { get set }
	var rotation: AnyObject { get set }
	var velocity: AnyObject { get set }
	var color: AnyObject { get set }
	var physics: String { get set }
	func rotate(rotation: AnyObject)
	func rotate(rotation: AnyObject, around anchorPoint: AnyObject)
}
