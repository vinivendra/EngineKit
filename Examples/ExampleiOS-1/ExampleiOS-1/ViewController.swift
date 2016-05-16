import UIKit
import EngineKitiOS
import SceneKit

class ViewController: UIViewController {
    @IBOutlet weak var sceneView: SCNView!

	var input: EKUIKitInputAddon?

	override func viewDidLoad() {
		super.viewDidLoad()

		let engine = EKEngine(languageEngine: EKJSCoreEngine())
		try! engine.loadAddon(EKSceneKitAddon(sceneView: sceneView))
		input = EKUIKitInputAddon(view: sceneView)
		try! engine.loadAddon(input!)
		try! engine.runScript(filename: "main.js")

		let lightnode = SCNNode()
		let light = SCNLight()
		lightnode.light = light
		lightnode.position = SCNVector3(10, 10, 10)
		sceneView.scene?.rootNode.addChildNode(lightnode)
	}

}
