import SceneKit

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

	public init(sceneView: SCNView) {
		self.sceneView = sceneView

		//
		self.scene = self.scene ?? SCNScene()
		self.sceneView.backgroundColor = OSFactory.yellowColor()
	}

	public func addFunctionalityToEngine(engine: EKLanguageEngine) {
		addGeometry(SCNPlane.self, toEngine:engine)
		addGeometry(SCNBox.self, toEngine:engine)
		addGeometry(SCNPyramid.self, toEngine:engine)
		addGeometry(SCNSphere.self, toEngine:engine)
		addGeometry(SCNCylinder.self, toEngine:engine)
		addGeometry(SCNCone.self, toEngine:engine)
		addGeometry(SCNTube.self, toEngine:engine)
		addGeometry(SCNCapsule.self, toEngine:engine)
		addGeometry(SCNTorus.self, toEngine:engine)
		addGeometry(SCNFloor.self, toEngine:engine)
		addGeometry(SCNText.self, toEngine:engine)
	}

	func addGeometry<T: SCNGeometry>(class: T.Type,
	                 toEngine engine: EKLanguageEngine) {
		let fullClassName = T.description().componentsSeparatedByString(".")
		let className = fullClassName.last?.toEKPrefixClassName()
		engine.addClass(T.self, withName: className, constructor: {
			let	geometry = T()
			let node = SCNNode(geometry: geometry)
			self.scene?.rootNode.addChildNode(node)
			return geometry
		})
	}
}
