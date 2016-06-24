import SGLOpenGL

var EKGLMVPMatrixID: GLint! = nil
var EKGLColorID: GLint! = nil
var EKGLProjectionViewMatrix = EKMatrix.identity

protocol EKGLObject {
	static var geometryWasInitialized: Bool { get set }

	var color: EKColorType { get set }

	var position: EKVector3 { get set }
	var scale: EKVector3 { get set }
	var rotation: EKVector4 { get set }

	static var vertexBuffer: [GLfloat]! { get }

	static var numberOfVertices: GLsizei! { get set }
	static var vertexBufferID: GLuint! { get set }
}

extension EKGLObject {
	var modelMatrix: EKMatrix {
		get {
			return position.translationToMatrix() *
				   scale.scaleToMatrix() *
				   rotation.rotationToMatrix()
		}
	}

	static func initializeGeometry() {
		if !Self.geometryWasInitialized {
			Self.geometryWasInitialized = true

			let vertexBuffer = Self.vertexBuffer

			let colorsBuffer = vertexBuffer.map {
				return ($0 + 1) / 2
			}

			Self.numberOfVertices = GLsizei(vertexBuffer.count) / 3

			var vertexID: GLuint = 0
			glGenBuffers(n: 1, buffers: &vertexID)
			glBindBuffer(target: GL_ARRAY_BUFFER, buffer: vertexID)
			glBufferData(target: GL_ARRAY_BUFFER,
			             size: sizeof([GLfloat]) * vertexBuffer.count,
			             data: vertexBuffer,
			             usage: GL_DYNAMIC_DRAW)

			Self.vertexBufferID = vertexID
		}
	}

	init() {
		Self.initializeGeometry()
		self.init()
	}

	func draw(withProjectionViewMatrix projectionViewMatrix: EKMatrix! = nil) {
		var projectionViewMatrix = projectionViewMatrix
		if projectionViewMatrix == nil {
			projectionViewMatrix = EKGLProjectionViewMatrix
		}

		glEnableVertexAttribArray(0)
		glBindBuffer(target: GL_ARRAY_BUFFER, buffer: Self.vertexBufferID)
		glVertexAttribPointer(
			index: 0, // Matching shader
			size: 3,
			type: GL_FLOAT,
			normalized: false,
			stride: 0,
			pointer: nil) // offset

		//
		let mvp = projectionViewMatrix * modelMatrix

		mvp.withGLFloatArray {
			glUniformMatrix4fv(location: EKGLMVPMatrixID,
			                   count: 1,
			                   transpose: false,
			                   value: $0)
		}

		color.withGLFloatArray {
			glUniform3fv(location: EKGLColorID,
						 count: 1,
						 value: $0)
		}

		//
		glDrawArrays(mode: GL_TRIANGLES,
		             first: 0,
		             count: Self.numberOfVertices)
		glDisableVertexAttribArray(0)
	}
}

class EKGLCube: EKGLObject {
	var position = EKVector3.origin()
	var scale = EKVector3(x: 1, y: 1, z: 1)
	var rotation = EKVector4(x: 1, y: 0, z: 0, w: 0)

	var color = EKVector4.whiteColor()

	static var geometryWasInitialized = false

	static var numberOfVertices: GLsizei! = nil
	static var vertexBufferID: GLuint! = nil

	static var vertexBuffer: [GLfloat]! {
		get {
			return [
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
				] as [GLfloat]
		}
	}

	init() {
		EKGLCube.initializeGeometry()
	}
}

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

extension EKColorType {
	public func withGLFloatArray<ReturnType>(
		closure: (UnsafePointer<GLfloat>) -> ReturnType) -> ReturnType {

		let components = self.components

		let array: [GLfloat] =
			[GLfloat(components.red),
			 GLfloat(components.green),
			 GLfloat(components.blue)]
		return array.withUnsafeBufferPointer {
			return closure($0.baseAddress)
		}
	}
}

//
func loadShaders(vertexFilePath vertexFilePath: String,
                 fragmentFilePath: String) -> GLuint {
	let vertexShaderID = glCreateShader(GL_VERTEX_SHADER)
	let fragmentShaderID = glCreateShader(GL_FRAGMENT_SHADER)

	let fileManager = OSFactory.createFileManager()
	let vertexShaderCode = fileManager.getContentsFromFile(vertexFilePath)!
	let fragmentShaderCode = fileManager.getContentsFromFile(fragmentFilePath)!

		var result: GLint = GL_FALSE
		var infoLogLength: GLint = 0

	print("Compiling shader: \(vertexFilePath)")
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
		glGetShaderInfoLog(vertexShaderID, infoLogLength, nil, string.buffer)
		print(String.fromCString(string.buffer))
	}

	//
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

	//
	glGetShaderiv(fragmentShaderID, GL_COMPILE_STATUS, &result)
	glGetShaderiv(fragmentShaderID, GL_INFO_LOG_LENGTH, &infoLogLength)
	if infoLogLength > 0 {
		let string = CString(emptyStringWithlength: Int(infoLogLength))
		glGetShaderInfoLog(fragmentShaderID, infoLogLength, nil, string.buffer)
		print(String.fromCString(string.buffer))
	}

	//
	print("Linking program")
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
