import SceneKit

#if os(OSX)
	typealias OSColor = NSColor
	typealias SCNNumber = CGFloat
#else
	typealias OSColor = UIColor
	typealias SCNNumber = Float
#endif

//
public class EKSceneKitAddon: EKLanguageAddon {

	let ekScene: EKScene

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

	let camera = EKCamera()

	public init(sceneView view: SCNView) {
		self.sceneView = view
		self.ekScene = EKScene(sceneView: view)

		view.scene = view.scene ?? SCNScene()
		self.scene?.rootNode.addChildNode(camera.node)
		self.sceneView.backgroundColor = OSColor.darkGrayColor()
	}

	public func addFunctionality(toEngine engine: EKEngine) {
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

		try! engine.addObject(camera, withName: "ekCamera")

		try! engine.addObject(ekScene, withName: "ekScene")
	}

}

@objc protocol SceneExport: JSExport {
	func objects(inCoordinate coordinate: AnyObject) -> [AnyObject]
}

public class EKScene: NSObject, Scriptable, SceneExport {
	let sceneView: SCNView
	var scene: SCNScene? {
		get {
			return sceneView.scene
		}
		set {
			sceneView.scene = newValue
		}
	}

	init(sceneView: SCNView) {
		self.sceneView = sceneView
		super.init()
	}

	public func objects(inCoordinate object: AnyObject) -> [AnyObject] {
		let coordinate = EKVector2.createVector(object: object)
		let point = coordinate.toCGPoint()
		let hitTests = sceneView.hitTest(point, options: nil)
		let scnNodes = hitTests.map { $0.node }
		let ekNodes = scnNodes.map(EKNode.init)
		return ekNodes
	}
}

extension EKVector3 {
	func toSCNVector3() -> SCNVector3 {
		return SCNVector3(x, y, z)
	}

	static func createVector(SCNVector3 vector: SCNVector3) -> EKVector3 {
		return EKVector3.createVector(x: Double(vector.x),
		                              y: Double(vector.y),
		                              z: Double(vector.z))
	}
}

extension EKVector4Type {
	func toSCNVector4() -> SCNVector4 {
		return SCNVector4(x, y, z, w)
	}

	func toSCNVector3() -> SCNVector3 {
		return SCNVector3(x, y, z)
	}

	static func createVector(SCNVector4 vector: SCNVector4) -> EKVector4 {
		return EKVector4.createVector(x: Double(vector.x),
		                              y: Double(vector.y),
		                              z: Double(vector.z),
		                              w: Double(vector.w))
	}
}

extension EKMatrix {
	func toSCNMatrix4() -> SCNMatrix4 {
		return SCNMatrix4(m11: SCNNumber(m11), m12: SCNNumber(m12),
		                  m13: SCNNumber(m13), m14: SCNNumber(m14),
		                  m21: SCNNumber(m21), m22: SCNNumber(m22),
		                  m23: SCNNumber(m23), m24: SCNNumber(m24),
		                  m31: SCNNumber(m31), m32: SCNNumber(m32),
		                  m33: SCNNumber(m33), m34: SCNNumber(m34),
		                  m41: SCNNumber(m41), m42: SCNNumber(m42),
		                  m43: SCNNumber(m43), m44: SCNNumber(m44))
	}

	static func createMatrix(SCNMatrix4 m: SCNMatrix4) -> EKMatrix {
		return EKMatrix(m11: Double(m.m11), m12: Double(m.m12),
		                m13: Double(m.m13), m14: Double(m.m14),
		                m21: Double(m.m21), m22: Double(m.m22),
		                m23: Double(m.m23), m24: Double(m.m24),
		                m31: Double(m.m31), m32: Double(m.m32),
		                m33: Double(m.m33), m34: Double(m.m34),
		                m41: Double(m.m41), m42: Double(m.m42),
		                m43: Double(m.m43), m44: Double(m.m44))
	}
}

@objc protocol NodeExport: JSExport {
	var position: AnyObject { get set }
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
	var rotation: AnyObject { get set }
	var velocity: AnyObject { get set }
	var color: AnyObject { get set }
	var physics: String { get set }
	func rotate(rotation: AnyObject)
	func rotate(rotation: AnyObject, around anchorPoint: AnyObject)
}
