import CGLFW3
import SGLOpenGL

import Darwin

//
extension EKMatrix {
	public func withGLFloatArray<ReturnType>(
		closure: (UnsafePointer<GLfloat>) -> ReturnType) -> ReturnType {

		let array: [GLfloat] =
			[GLfloat(m11), GLfloat(m12), GLfloat(m13), GLfloat(m14),
			 GLfloat(m21), GLfloat(m22), GLfloat(m23), GLfloat(m24),
			 GLfloat(m31), GLfloat(m32), GLfloat(m33), GLfloat(m34),
			 GLfloat(m41), GLfloat(m42), GLfloat(m43), GLfloat(m44)]
		return array.withUnsafeBufferPointer {
			return closure($0.baseAddress)
		}
	}
}

func EKToRadians(degrees: Double) -> Double {
	return degrees / 180 * Double(M_PI)
}

//
class CString {
	private let _len: Int
	var buffer: UnsafeMutablePointer<Int8>

	init(_ string: String) {
		(_len, buffer) = string.withCString {
			let len = Int(strlen($0) + 1)
			let dst = strcpy(UnsafeMutablePointer<Int8>.alloc(len), $0)
			return (len, dst)
		}
	}

	deinit {
		buffer.dealloc(_len)
	}
}

extension String {
	init?(contentsOfFileAtPath filePath: String) {
		var fileContents = ""
		let fp = fopen(filePath, "r")
		defer { fclose(fp) }

		if fp != nil {
			var buffer = [CChar](count: 1024, repeatedValue: CChar(0))
			while fgets(&buffer, Int32(1024), fp) != nil {
				fileContents = fileContents + String.fromCString(buffer)!
			}
			self.init(fileContents)
		} else {
			return nil
		}
	}

	func withCStringPointer<ReturnType>(
		@noescape closure: (UnsafePointer<UnsafePointer<Int8>>) -> ReturnType)
		-> ReturnType {

			let cString = CString(self)
			return withUnsafePointer(&(cString.buffer)) {
				(pointer: UnsafePointer<UnsafeMutablePointer<Int8>>)
				-> ReturnType in
				let foo = unsafeBitCast(pointer,
				                        UnsafePointer<UnsafePointer<Int8>>.self)
				return closure(foo)
			}
	}
}

//
let width: GLfloat = 800
let height: GLfloat = 600

func loadShaders(vertexFilePath vertexFilePath: String,
                 fragmentFilePath: String) -> GLuint {
	let vertexShaderID = glCreateShader(GL_VERTEX_SHADER)
	let fragmentShaderID = glCreateShader(GL_FRAGMENT_SHADER)

	let vertexShaderCode = String(contentsOfFileAtPath: vertexFilePath)!
	let fragmentShaderCode = String(contentsOfFileAtPath: fragmentFilePath)!

	//	var result: GLint = GL_FALSE
	//	var infoLogLength: GLint = 0

	print("Compiling shader: \(vertexFilePath)")
	vertexShaderCode.withCStringPointer {
		glShaderSource(vertexShaderID,
		               1,
		               $0,
		               nil)
	}

	glCompileShader(vertexShaderID)

	print("Compiling shader: \(fragmentFilePath)")
	let fragmentShaderCString = CString(fragmentShaderCode)
	withUnsafePointer(&(fragmentShaderCString.buffer)) {
		(pointer: UnsafePointer<UnsafeMutablePointer<Int8>>) -> Void in
		let foo = unsafeBitCast(pointer, UnsafePointer<UnsafePointer<Int8>>.self)
		glShaderSource( fragmentShaderID,
		                1,
		                foo,
		                nil)
	}

	glCompileShader(fragmentShaderID)

	print("Linking program")
	let programID = glCreateProgram()
	glAttachShader(programID, vertexShaderID)
	glAttachShader(programID, fragmentShaderID)
	glLinkProgram(programID)

	glDetachShader(programID, vertexShaderID)
	glDetachShader(programID, fragmentShaderID)

	glDeleteShader(vertexShaderID)
	glDeleteShader(fragmentShaderID)

	return programID
}

class EKGLObject {
	static var mvpMatrixID: GLint! = nil
	static var projectionViewMatrix = EKMatrix.identity

	let verticesBuffer: [GLfloat] =
		[
			-1.0,-1.0,-1.0,
			-1.0,-1.0, 1.0,
			-1.0, 1.0, 1.0,
			1.0, 1.0,-1.0,
			-1.0,-1.0,-1.0,
			-1.0, 1.0,-1.0,
			1.0,-1.0, 1.0,
			-1.0,-1.0,-1.0,
			1.0,-1.0,-1.0,
			1.0, 1.0,-1.0,
			1.0,-1.0,-1.0,
			-1.0,-1.0,-1.0,
			-1.0,-1.0,-1.0,
			-1.0, 1.0, 1.0,
			-1.0, 1.0,-1.0,
			1.0,-1.0, 1.0,
			-1.0,-1.0, 1.0,
			-1.0,-1.0,-1.0,
			-1.0, 1.0, 1.0,
			-1.0,-1.0, 1.0,
			1.0,-1.0, 1.0,
			1.0, 1.0, 1.0,
			1.0,-1.0,-1.0,
			1.0, 1.0,-1.0,
			1.0,-1.0,-1.0,
			1.0, 1.0, 1.0,
			1.0,-1.0, 1.0,
			1.0, 1.0, 1.0,
			1.0, 1.0,-1.0,
			-1.0, 1.0,-1.0,
			1.0, 1.0, 1.0,
			-1.0, 1.0,-1.0,
			-1.0, 1.0, 1.0,
			1.0, 1.0, 1.0,
			-1.0, 1.0, 1.0,
			1.0,-1.0, 1.0
	]

	let colorsBuffer: [GLfloat]

	private(set) var numberOfVertices: GLsizei

	var modelMatrix = EKMatrix.identity

	let colorBufferID: GLuint
	let vertexBufferID: GLuint

	init() {
		self.numberOfVertices = GLsizei(verticesBuffer.count) / 3

		self.colorsBuffer = self.verticesBuffer.map {
			return ($0 + 1) / 2
		}

		var vertexBufferID: GLuint = 0
		glGenBuffers(n: 1, buffers: &vertexBufferID)
		glBindBuffer(target: GL_ARRAY_BUFFER, buffer: vertexBufferID)
		glBufferData(target: GL_ARRAY_BUFFER,
		             size: sizeof([GLfloat]) * self.verticesBuffer.count,
		             data: self.verticesBuffer,
		             usage: GL_DYNAMIC_DRAW)

		var colorBufferID: GLuint = 0
		glGenBuffers(n: 1, buffers: &colorBufferID)
		glBindBuffer(target: GL_ARRAY_BUFFER, buffer: colorBufferID)
		glBufferData(target: GL_ARRAY_BUFFER,
		             size: sizeof([GLfloat]) * self.colorsBuffer.count,
		             data: self.colorsBuffer,
		             usage: GL_DYNAMIC_DRAW)

		self.colorBufferID = colorBufferID
		self.vertexBufferID = vertexBufferID
	}

	func draw(withProjectionViewMatrix projectionViewMatrix: EKMatrix! = nil) {
		var projectionViewMatrix = projectionViewMatrix
		if projectionViewMatrix == nil {
			projectionViewMatrix = EKGLObject.projectionViewMatrix
		}

		glEnableVertexAttribArray(0)
		glBindBuffer(target: GL_ARRAY_BUFFER, buffer: vertexBufferID)
		glVertexAttribPointer(
			index: 0, // Matching shader
			size: 3,
			type: GL_FLOAT,
			normalized: false,
			stride: 0,
			pointer: nil) // offset

		glEnableVertexAttribArray(1)
		glBindBuffer(target: GL_ARRAY_BUFFER, buffer: colorBufferID)
		glVertexAttribPointer(
			index: 1, // Matching shader
			size: 3,
			type: GL_FLOAT,
			normalized: false,
			stride: 0,
			pointer: nil) // offset

		//
		let mvp = projectionViewMatrix * modelMatrix

		mvp.withGLFloatArray {
			glUniformMatrix4fv(location: EKGLObject.mvpMatrixID,
			                   count: 1,
			                   transpose: false,
			                   value: $0)
		}

		//
		glDrawArrays(mode: GL_TRIANGLES,
		             first: 0,
		             count: numberOfVertices)
		glDisableVertexAttribArray(0)
		glDisableVertexAttribArray(1)
	}
}

class MyEngine: EKSwiftEngine {
	override func runProgram() {
		if glfwInit() == 0 {
			print("Error: glfwInit")
			return
		}
		defer { glfwTerminate() }

		// Set all the required options for GLFW
		glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3)
		glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3)
		glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE)
		glfwWindowHint(GLFW_RESIZABLE, GL_FALSE)
		glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE)

		let window = glfwCreateWindow(1024, 768, "Tutorial 01", nil, nil)
		if window == nil {
			print("Error: glfwCreateWindow")
			return
		}
		defer { glfwDestroyWindow(window) }

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

		//
		EKGLObject.mvpMatrixID = matrixID

		let object = EKGLObject()
		let object2 = EKGLObject()
		object.modelMatrix = EKMatrix.createTranslation(x: 0, y: 0, z: -1)
		object2.modelMatrix = EKMatrix.createTranslation(x: 0, y: 0, z: 1)

		//
		let projection = EKMatrix.createPerspective(
			fieldOfViewY: EKToRadians(45),
			aspect: Double(width / height),
			zNear: 0.1,
			zFar: 100)

		let view = EKMatrix.createLookAt(
			eye: EKVector3(x: 4, y: 3, z: 3),
			center: EKVector3(x: 0, y: 0, z: 0),
			up: EKVector3(x: 0, y: 1, z: 0))

		EKGLObject.projectionViewMatrix = projection * view

		/////////////////////
		repeat {
			glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

			object.draw()
			object2.draw()

			glfwSwapBuffers(window)
			glfwPollEvents()
		} while glfwGetKey(window, GLFW_KEY_ESCAPE) != GLFW_PRESS &&
			glfwWindowShouldClose(window) == 0
	}
}

let engine = EKEngine()
let swiftEngine = MyEngine(engine: engine)
engine.languageEngine = swiftEngine
engine.loadAddon(EKOpenGLAddon())
swiftEngine.runProgram()
