import CGLFW3

let EKOpenGLWindowWidth: GLfloat = 1024
let EKOpenGLWindowHeight: GLfloat = 768

let NULL = UnsafeMutablePointer<Int32>(bitPattern: 4)!.predecessor()

public class EKOpenGLAddon: EKAddon, EKLanguageCompatible {
	public let projection = EKMatrix.createPerspective(
		fieldOfViewY: EKToRadians(45),
		aspect: Double(EKOpenGLWindowWidth / EKOpenGLWindowHeight),
		zNear: 0.1,
		zFar: 100)

	private var window: OpaquePointer! = nil
	private var inputHandler: EKUnixInputAddon! = nil

	public func setup(onEngine engine: EKEngine) {
		if glfwInit() == 0 {
			print("Error: glfwInit")
			fatalError()
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
			fatalError()
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
		                            fragmentFilePath: "../../fragment.glsl")!
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

	private func checkCompilerStatus(forID shaderID: GLuint,
	                                 status: GLint) -> Bool {
		var result: GLint = GL_FALSE
		var infoLogLength: GLint = 0

		glGetShaderiv(shader: shaderID,
		              pname: status,
		              params: &result)
		glGetShaderiv(shader: shaderID,
		              pname: GL_INFO_LOG_LENGTH,
		              params: &infoLogLength)
		if infoLogLength > 0 {
			let string = CString(emptyStringWithlength: Int(infoLogLength))
			glGetShaderInfoLog(
				shader: shaderID,
				bufSize: infoLogLength,
				length: NULL,
				infoLog: string.buffer)
			print(String(validatingUTF8: string.buffer))
			return false
		}

		return true
	}

	private func compileShader(ofType shaderType: GLenum,
	                           inFilePath filePath: String) -> GLuint? {
		let fileManager = OSFactory.createFileManager()

		let shaderID = glCreateShader(type: shaderType)
		let shaderCode = fileManager.getContentsFromFile(filePath)!

		shaderCode.withCStringPointer { pointer in
			glShaderSource(
				shader: shaderID,
				count: 1,
				string: pointer,
				length: NULL)
		}

		glCompileShader(shaderID)

		let shaderDidCompile = checkCompilerStatus(forID: shaderID,
		                                           status: GL_COMPILE_STATUS)

		return shaderDidCompile ? shaderID : nil
	}

	private func linkShaders(vertexShaderID: GLuint,
	                         fragmentShaderID: GLuint) -> GLuint? {
		let programID = glCreateProgram()
		glAttachShader(program: programID, shader: vertexShaderID)
		glAttachShader(program: programID, shader: fragmentShaderID)
		glLinkProgram(programID)

		let programDidLink = checkCompilerStatus(
			forID: programID, status: GL_LINK_STATUS)
		guard programDidLink else { return nil }

		glDetachShader(program: programID, shader: vertexShaderID)
		glDetachShader(program: programID, shader: fragmentShaderID)

		return programID
	}

	private func loadShaders(vertexFilePath vertexPath: String,
							 fragmentFilePath fragmentPath: String) -> GLuint? {
		guard let vertexShaderID = compileShader(ofType: GL_VERTEX_SHADER,
												 inFilePath: vertexPath)
			else {
				return nil
		}
		defer { glDeleteShader(vertexShaderID) }

		guard let fragmentShaderID = compileShader(ofType: GL_FRAGMENT_SHADER,
		                                           inFilePath: fragmentPath)
			else {
				return nil
		}
		defer { glDeleteShader(fragmentShaderID) }

		guard let programID = linkShaders(vertexShaderID: vertexShaderID,
		                                  fragmentShaderID: fragmentShaderID)
			else {
				return nil
		}
		
		return programID
	}

	public func loopOpenGL(){
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
