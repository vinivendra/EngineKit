
import Cocoa
import EngineKitOSX
import SceneKit

class ViewController: NSViewController {

	@IBOutlet weak var sceneView: SCNView!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		let engine = EKEngine(languageEngine: EKJSCoreEngine())
		engine.loadAddon(EKSceneKitAddon(sceneView: sceneView))
		try! engine.runScript(filename: "main.js")
	}
}
