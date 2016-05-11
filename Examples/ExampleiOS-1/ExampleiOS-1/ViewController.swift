
import UIKit
import EngineKitiOS
import SceneKit

class ViewController: UIViewController {
    @IBOutlet weak var sceneView: SCNView!

	override func viewDidLoad() {
		super.viewDidLoad()

		let engine = EKEngine(languageEngine: EKJSCoreEngine())
		engine.loadAddon(EKSceneKitAddon(sceneView: sceneView))
		engine.runScript(filename: "main.js")
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}
