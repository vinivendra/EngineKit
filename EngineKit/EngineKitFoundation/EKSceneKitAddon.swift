import SceneKit

#if os(OSX)
	typealias OSColor = NSColor
#else
	typealias OSColor = UIColor
#endif

extension EKColor {
	func toObject() -> AnyObject {
		if let object = self as? AnyObject {
			return object
		} else {
			let rgba = self.components
			return OSColor(red: CGFloat(rgba.red),
			               green: CGFloat(rgba.green),
			               blue: CGFloat(rgba.blue),
			               alpha: CGFloat(rgba.alpha))
		}
	}
}

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

public class EKShape: NSObject {
	let node = SCNNode(geometry: SCNSphere())

	var position: [CGFloat] {
		get {
			return [CGFloat(node.position.x),
			        CGFloat(node.position.y),
			        CGFloat(node.position.z)]
		}
		set {
			node.position = SCNVector3(newValue[0], newValue[1], newValue[2])
		}
	}

	var color: AnyObject {
		get {
			let contents = node.geometry?.materials.first?.ambient.contents
			if let contents = contents {
				return OSColor.createColor(withObject: contents).toObject()
			}

			return OSColor.whiteColor()
		}
		set {
			let color = OSColor.createColor(withObject: newValue)
			let material = SCNMaterial()

			let colorObject = color.toObject()

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
	var position: [CGFloat] { get set }
	var color: AnyObject { get set }
	var physics: String { get set }
}
