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
	}

	public func addFunctionalityToEngine(languageEngine: EKLanguageEngine) {

	}

}
