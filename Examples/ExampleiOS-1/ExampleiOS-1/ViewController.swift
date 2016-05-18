import UIKit
import EngineKitiOS
import SceneKit

class ViewController: UIViewController {
    @IBOutlet weak var sceneView: SCNView!

	var engine: EKEngine!

	override func viewDidLoad() {
		super.viewDidLoad()

		engine = EKEngine()

		let javaScriptEngine = EKJSCoreEngine(engine: engine)
		engine.languageEngine = javaScriptEngine

		engine.loadAddon(EKSceneKitAddon(sceneView: sceneView))
		engine.loadAddon(EKUIKitInputAddon(view: sceneView))
		try! engine.register(forEvent: EKEventTap.self,
		                     target: self,
		                     method: ViewController.respondToEvent(_:))
//		try! engine.register(self, forEvent: EKEventTap.self)
//		try! engine.register(self, forEvent: EKEventPan.self)
//		try! engine.register(self, forEvent: EKEventPinch.self)
//		try! engine.register(self, forEvent: EKEventRotation.self)
//		try! engine.register(self, forEvent: EKEventLongPress.self)
		try! engine.runScript(filename: "main.js")

		let lightnode = SCNNode()
		let light = SCNLight()
		lightnode.light = light
		lightnode.position = SCNVector3(10, 10, 10)
		sceneView.scene?.rootNode.addChildNode(lightnode)
	}

	func respondToEvent(event: EKEventTap) {
		print("Responding to event \(event)")
	}
}
