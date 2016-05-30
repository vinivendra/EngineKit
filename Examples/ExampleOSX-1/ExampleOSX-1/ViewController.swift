import Cocoa
import EngineKitOSX
import SceneKit

class ViewController: NSViewController {

	@IBOutlet weak var sceneView: SCNView!

	override func viewDidLoad() {
		super.viewDidLoad()

		let engine = EKEngine()
		let javaScriptEngine = EKJSCoreEngine(engine: engine)
		engine.languageEngine = javaScriptEngine
		engine.loadAddon(EKSceneKitAddon(sceneView: sceneView))
		try! engine.runScript(filename: "main.js")

		let lightnode = SCNNode()
		let light = SCNLight()
		lightnode.light = light
		lightnode.position = SCNVector3(10, 10, 10)
		sceneView.scene?.rootNode.addChildNode(lightnode)
	}

}
