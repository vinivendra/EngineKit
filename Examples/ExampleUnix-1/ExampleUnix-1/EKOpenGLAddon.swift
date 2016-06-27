import CGLFW3
import SGLOpenGL

let width: GLfloat = 800
let height: GLfloat = 600

public class EKOpenGLAddon: EKAddon, EKLanguageCompatible {

	let projection = EKMatrix.createPerspective(
		fieldOfViewY: EKToRadians(45),
		aspect: Double(width / height),
		zNear: 0.1,
		zFar: 100)

	var window: COpaquePointer! = nil
	var inputHandler: EKUnixInputAddon! = nil

	public func setup(onEngine engine: EKEngine) {
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

		//
		inputHandler = EKUnixInputAddon(window: window)
		engine.loadAddon(inputHandler)
		try! engine.addObject(self, withName: "OpenGL")
	}

	func loopOpenGL(){
		repeat {
			inputHandler?.update()

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
}
