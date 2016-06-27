class MyEngine: EKSwiftEngine {

	var openGL: EKOpenGLAddon! = nil

	override func runProgram() {
		openGL = objects["OpenGL"] as! EKOpenGLAddon

		//
		let object = EKGLCube()
		let object2 = EKGLCube()
		object.position = EKVector3(x: 0, y: 0, z: -1)
		object2.position = EKVector3(x: 0, y: 0, z: 1)

		object.rotation = EKVector4(x: 0, y: 0, z: 1, w: 0.3)
		object2.scale = EKVector3(x: 0.5, y: 0.5, z: 0.5)
		object2.rotation = EKVector4(x: 0, y: 0, z: 1, w: -0.3)

		object.color = EKVector4.purpleColor()
		object2.color = EKVector4.orangeColor()

		EKGLCamera.position = EKVector3(x: 0, y: 0, z: 10)
		EKGLCamera.rotation = EKVector4(x: 1, y: 1, z: 1, w: 0.1)

		//
		openGL.loopOpenGL()
	}
}

let engine = EKEngine()
let swiftEngine = MyEngine(engine: engine)
engine.languageEngine = swiftEngine
engine.loadAddon(EKOpenGLAddon())
try! engine.register(forEventNamed: "tap") { (event: EKEvent) in
	print("Tap!!")
}
try! engine.register(forEventNamed: "pan") { (event: EKEvent) in
	print("Pan!!")
}
try! engine.register(forEventNamed: "long press") { (event: EKEvent) in
	print("Long!!")
}
swiftEngine.runProgram()
