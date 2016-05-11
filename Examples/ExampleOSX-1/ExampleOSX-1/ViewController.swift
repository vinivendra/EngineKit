
import Cocoa
import EngineKitOSX

class ViewController: NSViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		let engine = EKEngine(languageEngine: EKJSCoreEngine())
		engine.runScript(atFileNamed: "main.js")
	}
}
