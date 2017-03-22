// swiftlint:disable force_cast
// swiftlint:disable force_try

import Foundation

let ekEngine = EKEngine()

class MyEngine: EKSwiftEngine {
	var openGL: EKOpenGLAddon! = nil

	// swiftlint:disable:next function_body_length
	override func runProgram() {
		openGL = objects["OpenGL"] as! EKOpenGLAddon

		//
		var ball = EKGLCube()
		ball.color = EKColor.grayColor()
		ball.position = EKVector3(x: 0, y: 3, z: -10)
		ball.name = "white cube"
		ball.setupPhysicsComponent()

		ball = EKGLCube()
		ball.color = EKColor.grayColor()
		ball.position = EKVector3(x: 0.9, y: 6, z: -10)
		ball.name = "white cube"
		ball.setupPhysicsComponent()

		let ball2 = EKGLCube()
		ball2.color = EKColor.grayColor()
		ball2.position = EKVector3(x: 3, y: 0, z: 0)
		ball2.name = "white cube"
		ball.addChild(ball2)

//		let ball2 = EKGLCube()
//		ball2.color = EKColor.grayColor()
//		ball2.position = EKVector3(x: -2, y: -1, z: 0)
//		ball2.name = "gray cube"
//		ball.addChild(ball2)

		EKGLCamera.mainCamera.position = EKVector3(x: 0, y: 0, z: 10)

//		let jsonTranslateTargets = [[-1, 1, 1], [0, 0, 0.5], [-2, -1, 0]]
//		let jsonRotateTargets = [[0, 1, 0, 1], [1, 0, 0, 1], [0, 0, 1, 0]]
//		let jsonScaleTargets = [[0.5, 0.5, 0.5], [0.5, 2, 0.5], [1, 1, 1]]
//		let jsonColorTargets = [[0.2, 0.3, 0.4], [0.5, 0.4, 0.3], [0.5, 0.2, 0.3]]
//		let jsonCommand: [[String: Any]] =
//			[
//				[
//					"action": "translate",
//					"parameters": [
//						"id": ball2.objectID!,
//						"targets": jsonTranslateTargets
//					]
//				],
//				[
//					"action": "rotate",
//					"parameters": [
//						"id": ball2.objectID!,
//						"targets": jsonRotateTargets
//					]
//				],
//				[
//					"action": "scale",
//					"parameters": [
//						"id": ball2.objectID!,
//						"targets": jsonScaleTargets
//					]
//				],
//				[
//					"action": "changeColor",
//					"parameters": [
//						"id": ball2.objectID!,
//						"targets": jsonColorTargets
//					]
//				],
//				[
//					"action": "changeName",
//					"parameters": [
//						"id": ball2.objectID!,
//						"name": "my new name"
//					]
//				],
//				[
//					"action": "add",
//					"parameters": [
//						"mesh": "cube",
//						"color": "purple",
//						"name": "json object",
//						"position": [2, 1, 0],
//						"scale": 0.7,
//						"rotation": [0.3, 0.3, 0.3, 0.3],
//						"children": [
//							["mesh": "cube",
//							 "color": "orange",
//							 "name": "json object 2",
//							 "position": [2, 1, 0],
//							 "scale": 0.7,
//							 "rotation": [0.3, 0.3, 0.3, 0.3]
//							]
//						]
//					]
//				]
//				//				,[
//				//					"action": "remove",
//				//					"parameters": [
//				//						"id": ball2.objectID!
//				//					]
//				//				]
//		]
//
//		print("Old name = \(ball2.name)")
//
//		let data = try! JSONSerialization.data(withJSONObject: jsonCommand)
//		let json = try! JSONSerialization.jsonObject(with: data)
//		let actionsArray = json as! [[String: Any]]
//
//		for action in actionsArray {
//			EKCommand.applyCommand(fromJSON: action)
//		}
//
//		print("New name = \(ball2.name)")
//
		//
		//		let ballJSON = ball.exportToJSON()
		//		ball.destroy()
		//		let jsonAction: [String: Any] = ["action": "add",
		//		                                 "parameters": ballJSON]
		//		EKCommand.applyCommand(fromJSON: jsonAction)

		//

		openGL.loopOpenGL()
	}
}

let swiftEngine = MyEngine(engine: ekEngine)
ekEngine.languageEngine = swiftEngine
ekEngine.loadAddon(EKOpenGLAddon())
ekEngine.loadAddon(EKBulletAddon())

try! ekEngine.register(forEvent: EKEventPan.self) { (eventPan: EKEventPan) in
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
		camera.rotate(rot.normalized(), around: EKVector3())
	}
}

try! ekEngine.register(forEvent: EKEventTap.self) { (eventTap: EKEventTap) in
	let object = EKGLObject.object(atPixel: eventTap.position)
	print("Tapped \(object?.name)")
}

swiftEngine.runProgram()
