import SceneKit

#if os(OSX)
	typealias OSColor = NSColor
#else
	typealias OSColor = UIColor
#endif

//
public class EKSceneKitAddon: EKLanguageAddon {

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

	public func addClasses(toEngine engine: EKEngine) {
		engine.addClass(EKSphere.self, withName: nil, constructor: {
			let sphere = EKSphere()
			self.scene?.rootNode.addChildNode(sphere.node)
			return sphere
		})

		engine.addClass(EKBox.self, withName: nil, constructor: {
			let box = EKBox()
			self.scene?.rootNode.addChildNode(box.node)
			return box
		})
	}

}

extension EKVector3Type {
	func toSCNVector3() -> SCNVector3 {
		return SCNVector3(x, y, z)
	}

	static func createVector(SCNVector3 vector: SCNVector3) -> Self {
		return Self.createVector(x: Double(vector.x),
		                         y: Double(vector.y),
		                         z: Double(vector.z))
	}
}

extension EKVector4Type {
	func toSCNVector4() -> SCNVector4 {
		return SCNVector4(x, y, z, w)
	}

	static func createVector(SCNVector4 vector: SCNVector4) -> Self {
		return Self.createVector(x: Double(vector.x),
		                         y: Double(vector.y),
		                         z: Double(vector.z),
		                         w: Double(vector.w))
	}
}

public class EKShape: NSObject {
	let node = SCNNode()

	var position: AnyObject {
		get {
			return EKNSVector3.createVector(SCNVector3: node.position)
		}
		set {
			let vector = EKNSVector3.createVector(object: newValue)
			node.position = vector.toSCNVector3()
		}
	}

	var rotation: AnyObject {
		get {
			return EKNSVector4.createVector(SCNVector4: node.rotation)
		}
		set {
			let vector = EKNSVector4.createVector(object: newValue)
			node.rotation = vector.toSCNVector4()
		}
	}

	var velocity: AnyObject {
		get {
			if let velocity = node.physicsBody?.velocity {
				return EKNSVector3.createVector(SCNVector3: velocity)
			}
			return EKNSVector3.origin()
		}
		set {
			let vector = EKNSVector3.createVector(object: newValue)
			node.physicsBody?.velocity = vector.toSCNVector3()
		}
	}

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
}

//
public class EKSphere: EKShape, SphereExport, Scriptable {
	override public required init() {
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
	var rotation: AnyObject { get set }
	var velocity: AnyObject { get set }
	var color: AnyObject { get set }
	var physics: String { get set }
}

//
public class EKBox: EKShape, BoxExport, Scriptable {
	override required public init() {
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
	var rotation: AnyObject { get set }
	var velocity: AnyObject { get set }
	var color: AnyObject { get set }
	var physics: String { get set }
}
