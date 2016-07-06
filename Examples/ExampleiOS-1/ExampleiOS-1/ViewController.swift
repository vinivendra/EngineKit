import UIKit
import EngineKitiOS
import SceneKit

class ViewController: UIViewController {
    @IBOutlet weak var sceneView: SCNView!

	override func viewDidLoad() {
		super.viewDidLoad()

		let engine = EKEngine()
		let javaScriptEngine = EKJSCoreEngine(engine: engine)
		engine.languageEngine = javaScriptEngine
		engine.loadAddon(EKSceneKitAddon(sceneView: sceneView))
		engine.loadAddon(EKUIKitInputAddon(view: sceneView))
		try! javaScriptEngine.runScript(filename: "main.js")

		let lightnode = SCNNode()
		let light = SCNLight()
		lightnode.light = light
		lightnode.position = SCNVector3(10, 10, 10)
		sceneView.scene?.rootNode.addChildNode(lightnode)
	}
}
