// swiftlint:disable force_cast
// swiftlint:disable force_try

import Foundation

class MyEngine: EKSwiftEngine {
	var openGL: EKOpenGLAddon! = nil

	override func runProgram() {
		openGL = objects["OpenGL"] as! EKOpenGLAddon

		//
		let ball = EKGLCube()
		ball.color = EKVector4.whiteColor()
		ball.position = EKVector3(x: 1, y: 1, z: 0)
		ball.name = "white"
		let ball2 = EKGLCube()
		ball2.color = EKVector4.grayColor()
		ball2.position = EKVector3(x: -2, y: -1, z: 0)
		ball2.name = "gray"
		ball.addChild(ball2)

		EKGLCamera.mainCamera.position = EKVector3(x: 0, y: 0, z: 10)

		let jsonTranslateTargets = [[1.5, 2.6, 3.7], [0, 0, 1], [-2, -1, 0]]
		let jsonRotateTargets = [[0, 1, 0, 1], [1, 0, 0, 1], [0, 0, 1, 0]]
		let jsonCommand: [[String: Any]] =
			[
				[ // action: translate
					"action": "translate",
					"parameters": [
						"id": 987654321,
						"targets": jsonTranslateTargets
					]
				],
				[ // action: rotate
					"action": "rotate",
					"parameters": [
						"id": 987654321,
						"targets": jsonRotateTargets
					]
				]
			]

		let data = try! JSONSerialization.data(withJSONObject: jsonCommand)
		let json = try! JSONSerialization.jsonObject(with: data)
		let actionsArray = json as! [[String: Any]]
		let actionTranslate = actionsArray[0]
		let actionRotate = actionsArray[1]

		let commandTranslate = EKCommandCreate(fromJSON: actionTranslate)!
		commandTranslate.apply(to: ball2)
		let commandRotate = EKCommandCreate(fromJSON: actionRotate)!
		commandRotate.apply(to: ball2)

		//
		openGL.loopOpenGL()
	}
}

let engine = EKEngine()
let swiftEngine = MyEngine(engine: engine)
engine.languageEngine = swiftEngine
engine.loadAddon(EKOpenGLAddon())

try! engine.register(forEvent: EKEventPan.self) { (eventPan: EKEventPan) in
	let object = EKGLObject.object(atPixel: eventPan.position)

	let camera = EKGLCamera.mainCamera

	if let object = object {
		let resized = eventPan.displacement.times(0.01)
		let translation = camera.xAxis.times(resized.x).plus(
						  camera.yAxis.times(resized.y))
		let distance = object.position.minus(camera.position)
		let ratio = distance.norm() / 7.5

		let resizedTranslation = translation.times(ratio)

		object.position = object.position.translate(translation)
	} else {
		let resized = eventPan.displacement.times(0.01)

		let axis = camera.xAxis.times(resized.y).plus(
				   camera.yAxis.times(-resized.x))
		let rot = EKVector4(x: axis.x, y: axis.y, z: axis.z,
							w: resized.normSquared())
		camera.rotate(rot.normalized(), around: EKVector3.origin())
	}
}

try! engine.register(forEvent: EKEventTap.self) { (eventTap: EKEventTap) in
	let object = EKGLObject.object(atPixel: eventTap.position)
	print("Tapped \(object?.name)")
}

swiftEngine.runProgram()
