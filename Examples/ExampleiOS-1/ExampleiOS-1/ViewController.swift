
import UIKit
import EngineKitiOS

class ViewController: UIViewController {
    @IBOutlet weak var sceneView: SCNView!

	override func viewDidLoad() {
		super.viewDidLoad()

		let engine = EKEngine(languageEngine: EKJSCoreEngine())
		engine.runScript(atFileNamed: "main.js")
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}
