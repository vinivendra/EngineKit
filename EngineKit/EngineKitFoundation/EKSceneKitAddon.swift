import SceneKit

#if os(OSX)
	typealias OSColor = NSColor
	typealias SCNNumber = CGFloat
#else
	typealias OSColor = UIColor
	typealias SCNNumber = Float
#endif

private extension CGPoint {
	func toEKVector2() -> EKVector2 {
		return EKVector2(x: Double(self.x), y: Double(-self.y))
	}
}

private extension EKVector2 {
	func toCGPoint() -> CGPoint {
		return CGPoint(x: self.x, y: -self.y)
	}
}

//
public class EKSceneKitAddon: EKScriptAddon {

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

public class EKScene: NSObject, EKLanguageCompatible, SceneExport {
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
