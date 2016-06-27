class MyEngine: EKSwiftEngine {
	var openGL: EKOpenGLAddon! = nil

	override func runProgram() {
		openGL = objects["OpenGL"] as! EKOpenGLAddon

		//
		let ball = EKGLCube()
		ball.color = EKVector4.purpleColor()
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
swiftEngine.runProgram()
