import CGLFW3
import SGLOpenGL

import Darwin

//
let width: GLfloat = 800
let height: GLfloat = 600

class MyEngine: EKSwiftEngine {
	let projection = EKMatrix.createPerspective(
		fieldOfViewY: EKToRadians(45),
		aspect: Double(width / height),
		zNear: 0.1,
		zFar: 100)

	var window: COpaquePointer! = nil

	func setupOpenGL() {
		if glfwInit() == 0 {
			print("Error: glfwInit")
			return
		}

		// Set all the required options for GLFW
		glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3)
		glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3)
		glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE)
		glfwWindowHint(GLFW_RESIZABLE, GL_FALSE)
		glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE)

		window = glfwCreateWindow(1024, 768, "Tutorial 01", nil, nil)
		if window == nil {
			print("Error: glfwCreateWindow")
			glfwTerminate()
			return
		}

		glfwMakeContextCurrent(window)

		glfwSetInputMode(window, GLFW_STICKY_KEYS, GL_TRUE)

		//
		glEnable(GL_DEPTH_TEST)
		glDepthFunc(GL_LESS)

		/////////////////////
		var vertexArrayID: GLuint = 0
		glGenVertexArrays(n: 1, arrays: &vertexArrayID)
		glBindVertexArray(vertexArrayID)

		//
		let programID = loadShaders(vertexFilePath: "../../vertex.glsl",
		                            fragmentFilePath: "../../fragment.glsl")
		glUseProgram(programID)

		//
		let matrixID = glGetUniformLocation(program: programID, name: "MVP")
		let colorID = glGetUniformLocation(program: programID, name: "color")

		EKGLMVPMatrixID = matrixID
		EKGLColorID = colorID
	}

	func loopOpenGL(){
		repeat {
			EKGLProjectionViewMatrix = projection * EKGLCamera.viewMatrix

			glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

			for object in EKGLObjects {
				object.draw()
			}

			glfwSwapBuffers(window)
			glfwPollEvents()
		} while glfwGetKey(window, GLFW_KEY_ESCAPE) != GLFW_PRESS &&
			glfwWindowShouldClose(window) == 0

		glfwTerminate()
		glfwDestroyWindow(window)
	}

	override func runProgram() {
		setupOpenGL()
		main()
		loopOpenGL()
	}

	func main() {
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
	}
}

let engine = EKEngine()
let swiftEngine = MyEngine(engine: engine)
engine.languageEngine = swiftEngine
engine.loadAddon(EKOpenGLAddon())
swiftEngine.runProgram()
