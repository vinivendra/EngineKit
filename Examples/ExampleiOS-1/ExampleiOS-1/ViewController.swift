import UIKit
import EngineKitiOS
import SceneKit

class ViewController: UIViewController, EKEventListener {
    @IBOutlet weak var sceneView: SCNView!

	var engine: EKEngine!

	override func viewDidLoad() {
		super.viewDidLoad()

		engine = EKEngine(languageEngine: EKJSCoreEngine())
		engine.loadAddon(EKSceneKitAddon(sceneView: sceneView))
		engine.loadAddon(EKUIKitInputAddon(view: sceneView))
		try! engine.runScript(filename: "main.js")
		engine.register(self, forEvent: EKEventTap.self)

		let lightnode = SCNNode()
		let light = SCNLight()
		lightnode.light = light
		lightnode.position = SCNVector3(10, 10, 10)
		sceneView.scene?.rootNode.addChildNode(lightnode)
	}

	func respondToEvent(event: EKEvent) {
		if let tapEvent = event as? EKEventTap {
			print("tap \(tapEvent.position)")
		}
	}
}
