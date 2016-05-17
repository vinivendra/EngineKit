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
		try! engine.register(self, forEvent: EKEventTap.self)
		try! engine.register(self, forEvent: EKEventPan.self)
		try! engine.register(self, forEvent: EKEventPinch.self)
		try! engine.register(self, forEvent: EKEventRotation.self)
		try! engine.register(self, forEvent: EKEventLongPress.self)

		let lightnode = SCNNode()
		let light = SCNLight()
		lightnode.light = light
		lightnode.position = SCNVector3(10, 10, 10)
		sceneView.scene?.rootNode.addChildNode(lightnode)
	}

	func respondToEvent(event: EKEvent) {
		if let event = event as? EKEventTap {
			print("tap \(event.position)")
		} else if let event = event as? EKEventPan {
			print("pan \(event.position)")
		} else if let event = event as? EKEventPinch {
			print("pinch \(event.position)")
		} else if let event = event as? EKEventRotation {
			print("rotation \(event.position)")
		} else if let event = event as? EKEventLongPress {
			print("long press \(event.position)")
		}
	}
}
