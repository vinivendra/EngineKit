import SceneKit

#if os(OSX)
	typealias OSColor = NSColor
#else
	typealias OSColor = UIColor
#endif

public class EKSceneKitAddon: EKAddon {

	let sceneView: SCNView
	var scene: SCNScene? {
		get {
			return sceneView.scene
		}
		set {
			sceneView.scene = newValue
		}
	}

	var physicsWorld: SCNPhysicsWorld? {
		get {
			return sceneView.scene?.physicsWorld
		}
	}

	public init(sceneView: SCNView) {
		self.sceneView = sceneView

		//
		self.scene = self.scene ?? SCNScene()
		self.sceneView.backgroundColor = OSColor.darkGrayColor()
	}

	public func addFunctionalityToEngine(engine: EKLanguageEngine) {
		engine.addClass(EKSphere.self, withName: nil, constructor: {
			let sphere = EKSphere()
			self.scene?.rootNode.addChildNode(sphere.node)
			return sphere
		})
	}

}

//
public class EKSCNVector: EKVector {
	public let x: Double
	public let y: Double
	public let z: Double

	init(x: Double, y: Double, z: Double) {
		self.x = x
		self.y = y
		self.z = z
	}

	public static func createVector(x x: Double,
	                                  y: Double,
	                                  z: Double) -> EKVector {
		return EKSCNVector(x: x, y: y, z: z)
	}
}

extension EKVector {
	func toSCNVector3() -> SCNVector3 {
		return SCNVector3(x, y, z)
	}
}

public class EKShape: NSObject {
	let node = SCNNode(geometry: SCNSphere())

	var position: AnyObject {
		get {
			return [CGFloat(node.position.x),
			        CGFloat(node.position.y),
			        CGFloat(node.position.z)]
		}
		set {
			let vector = EKSCNVector.createVector(object: newValue)
			node.position = vector.toSCNVector3()
		}
	}

	var color: AnyObject {
		get {
			let contents = node.geometry?.materials.first?.ambient.contents
			if let contents = contents {
				return OSColor.createColor(withObject: contents)
			}

			return OSColor.whiteColor()
		}
		set {
			let color = OSColor.createColor(withObject: newValue)
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
}

//
public class EKSphere: EKShape, SphereExport {
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
	var color: AnyObject { get set }
	var physics: String { get set }
}
