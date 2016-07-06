import CGLFW3
import SGLOpenGL

let EKOpenGLWindowWidth: GLfloat = 1024
let EKOpenGLWindowHeight: GLfloat = 768

public class EKOpenGLAddon: EKAddon, EKLanguageCompatible {
	public let projection = EKMatrix.createPerspective(
		fieldOfViewY: EKToRadians(45),
		aspect: Double(EKOpenGLWindowWidth / EKOpenGLWindowHeight),
		zNear: 0.1,
		zFar: 100)

	private var window: COpaquePointer! = nil
	private var inputHandler: EKUnixInputAddon! = nil

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
		glEnable(GL_STENCIL_TEST)
		glStencilOp(GL_KEEP, GL_KEEP, GL_REPLACE)

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

		EKGLObject.mvpMatrixID = matrixID
		EKGLObject.colorID = colorID

		//
		inputHandler = EKUnixInputAddon(window: window)
		engine.loadAddon(inputHandler)
		try! engine.addObject(self, withName: "OpenGL")
	}

	private func loadShaders(vertexFilePath vertexPath: String,
							 fragmentFilePath fragmentPath: String)
			-> GLuint {
		let vertexShaderID = glCreateShader(GL_VERTEX_SHADER)
		let fragmentShaderID = glCreateShader(GL_FRAGMENT_SHADER)

		let fileManager = OSFactory.createFileManager()
		let vertexShaderCode = fileManager.getContentsFromFile(vertexPath)!
		let fragmentShaderCode = fileManager.getContentsFromFile(fragmentPath)!

		var result: GLint = GL_FALSE
		var infoLogLength: GLint = 0

		vertexShaderCode.withCStringPointer {
			glShaderSource(vertexShaderID,
				1,
				$0,
				nil)
		}

		glCompileShader(vertexShaderID)

		//
		glGetShaderiv(vertexShaderID, GL_COMPILE_STATUS, &result)
		glGetShaderiv(vertexShaderID, GL_INFO_LOG_LENGTH, &infoLogLength)
		if infoLogLength > 0 {
			let string = CString(emptyStringWithlength: Int(infoLogLength))
			glGetShaderInfoLog(shader: vertexShaderID,
			                   bufSize: infoLogLength,
			                   length: nil,
			                   infoLog: string.buffer)
			print(String.fromCString(string.buffer))
		}

		//
		let fragmentShaderCString = CString(fragmentShaderCode)
		withUnsafePointer(&(fragmentShaderCString.buffer)) {
			(pointer: UnsafePointer<UnsafeMutablePointer<Int8>>) -> Void in
			let foo = unsafeBitCast(pointer,
			                        UnsafePointer<UnsafePointer<Int8>>.self)
			glShaderSource( fragmentShaderID,
			                1,
			                foo,
			                nil)
		}

		glCompileShader(fragmentShaderID)

		//
		glGetShaderiv(fragmentShaderID, GL_COMPILE_STATUS, &result)
		glGetShaderiv(fragmentShaderID, GL_INFO_LOG_LENGTH, &infoLogLength)
		if infoLogLength > 0 {
			let string = CString(emptyStringWithlength: Int(infoLogLength))
			glGetShaderInfoLog(shader: fragmentShaderID,
			                   bufSize: infoLogLength,
			                   length: nil,
			                   infoLog: string.buffer)
			print(String.fromCString(string.buffer))
		}

		//
		let programID = glCreateProgram()
		glAttachShader(programID, vertexShaderID)
		glAttachShader(programID, fragmentShaderID)
		glLinkProgram(programID)

		//
		glGetShaderiv(programID, GL_LINK_STATUS, &result)
		glGetShaderiv(programID, GL_INFO_LOG_LENGTH, &infoLogLength)
		if infoLogLength > 0 {
			let string = CString(emptyStringWithlength: Int(infoLogLength))
			glGetShaderInfoLog(programID, infoLogLength, nil, string.buffer)
			print(String.fromCString(string.buffer))
		}

		//
		glDetachShader(programID, vertexShaderID)
		glDetachShader(programID, fragmentShaderID)

		glDeleteShader(vertexShaderID)
		glDeleteShader(fragmentShaderID)

		return programID
	}

	public func loopOpenGL() {
		var oldTime = glfwGetTime()
		repeat {
			let newTime = glfwGetTime()
			let deltaTime = newTime - oldTime
			EKTimer.updateTimers(deltaTime: deltaTime)
			inputHandler?.update()

			EKGLObject.projectionViewMatrix = projection *
											  EKGLCamera.mainCamera.viewMatrix

			glClearStencil(0)
			glClear(
				GL_COLOR_BUFFER_BIT |
				GL_DEPTH_BUFFER_BIT |
				GL_STENCIL_BUFFER_BIT)

			for object in EKGLObject.allObjects where object.parent == nil {
				object.draw()
			}

			glfwSwapBuffers(window)
			glfwPollEvents()

			oldTime = newTime
		} while glfwGetKey(window, GLFW_KEY_ESCAPE) != GLFW_PRESS &&
			glfwWindowShouldClose(window) == 0

		glfwTerminate()
		glfwDestroyWindow(window)
	}
}
