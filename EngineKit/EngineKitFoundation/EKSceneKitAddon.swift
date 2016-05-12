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
		self.sceneView.backgroundColor = OSFactory.darkGrayColor()
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
}

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
}
