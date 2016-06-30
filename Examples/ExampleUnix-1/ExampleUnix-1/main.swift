import SGLOpenGL

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

		EKGLCamera.position = EKVector3(x: 0, y: 0, z: 10)

		//
		openGL.loopOpenGL()
	}
}

let engine = EKEngine()
let swiftEngine = MyEngine(engine: engine)
engine.languageEngine = swiftEngine
engine.loadAddon(EKOpenGLAddon())

try! engine.register(forEvent: EKEventPan.self) { (eventPan: EKEventPan) in
	let resized = eventPan.displacement.times(0.01)

	let axis = EKGLCamera.xAxis.times(resized.y).plus(
			   EKGLCamera.yAxis.times(-resized.x))
	let rot = EKVector4(x: axis.x, y: axis.y, z: axis.z,
	                    w: resized.normSquared())
	EKGLCamera.rotate(rot.normalize(), around: EKVector3.origin())
}

try! engine.register(forEvent: EKEventTap.self) { (eventTap: EKEventTap) in
	let object = EKGLObjectAtPixel(eventTap.position)
	print("Tapped \(object?.name)")
}

swiftEngine.runProgram()
