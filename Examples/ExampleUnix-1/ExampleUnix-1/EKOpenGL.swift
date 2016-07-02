import SGLOpenGL

var EKGLMVPMatrixID: GLint! = nil
var EKGLColorID: GLint! = nil
var EKGLProjectionViewMatrix = EKMatrix.identity

var EKGLObjectPool = EKResourcePool<EKGLObject>()

func EKGLObjectAtPixel(pixel: EKVector2) -> EKGLObject? {
	var index: GLuint = 0
	let x = GLint(pixel.x) * 2
	let y = GLint(pixel.y) * 2
	glReadPixels(x, y, 1, 1,
	             GL_STENCIL_INDEX, GL_UNSIGNED_INT, &index);
	return EKGLObjectPool[Int(index)]
}

public struct EKGLMatrixComponent {
	public var position = EKVector3.origin() {
		didSet {
			_modelMatrix = nil
		}
	}
	public var scale = EKVector3(x: 1, y: 1, z: 1) {
		didSet {
			_modelMatrix = nil
		}
	}
	public var rotation = EKVector4(x: 1, y: 0, z: 0, w: 0) {
		didSet {
			_modelMatrix = nil
		}
	}

	private var _modelMatrix: EKMatrix? = nil

	public mutating func getMatrix() -> EKMatrix {
		guard let modelMatrix = _modelMatrix else {
			_modelMatrix = position.translationToMatrix() *
				scale.scaleToMatrix() *
				rotation.rotationToMatrix()
			return _modelMatrix!
		}
		return modelMatrix
	}

	init () {
		position = EKVector3(x: 0, y: 0, z: 0)
		scale = EKVector3(x: 1, y: 1, z: 1)
		rotation = EKVector4(x: 1, y: 0, z: 0, w: 0)
	}
}

public struct EKGLVertexComponent {
	private let vertices: [GLfloat]

	public let bufferID: GLuint
	public let numberOfVertices: GLsizei

	public init(vertices: [GLfloat]) {
		self.vertices = vertices
		self.numberOfVertices = GLsizei(vertices.count) / 3

		var tempBufferID: GLuint = 0
		glGenBuffers(n: 1, buffers: &tempBufferID)
		glBindBuffer(target: GL_ARRAY_BUFFER, buffer: tempBufferID)
		glBufferData(target: GL_ARRAY_BUFFER,
		             size: sizeof([GLfloat]) * vertices.count,
		             data: vertices,
		             usage: GL_DYNAMIC_DRAW)
		self.bufferID = tempBufferID
	}

	//
	public static let Cube = EKGLVertexComponent(vertices:
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
		])
}

public class EKGLObject: EKGLMatrixComposer {
	var poolIndex: Int? = nil

	var matrixComponent = EKGLMatrixComponent()
	let vertexComponent: EKGLVertexComponent?

	var color: EKColorType? = nil

	var name: String? = nil

	var children = [EKGLObject]()
	var parent: EKGLObject? = nil

	internal init(vertexComponent: EKGLVertexComponent) {
		self.vertexComponent = vertexComponent
		self.commonInit()
	}

	public init() {
		self.vertexComponent = nil
		self.commonInit()
	}
}

protocol EKGLMatrixComposer: class {
	var matrixComponent: EKGLMatrixComponent { get set }
	var position: EKVector3 { get set }
	var scale: EKVector3 { get set }
	var rotation: EKVector4 { get set }
	var modelMatrix: EKMatrix { get }
}

extension EKGLMatrixComposer {
	var position: EKVector3 {
		get {
			return matrixComponent.position
		}
		set {
			matrixComponent.position = newValue
		}
	}

	var scale: EKVector3 {
		get {
			return matrixComponent.scale
		}
		set {
			matrixComponent.scale = newValue
		}
	}

	var rotation: EKVector4 {
		get {
			return matrixComponent.rotation
		}
		set {
			matrixComponent.rotation = newValue
		}
	}

	var modelMatrix: EKMatrix {
		get {
			return matrixComponent.getMatrix()
		}
	}
}

extension EKGLObject {
	func commonInit() {
		if poolIndex == nil {
			poolIndex = EKGLObjectPool.addResourceAndGetIndex(self)
		}
	}

	func draw(withProjectionViewMatrix projectionViewMatrix: EKMatrix! = nil) {
		guard let vertexComponent = vertexComponent else { return }
		let color = self.color ?? EKVector4.whiteColor()

		//
		let completeMask: GLuint = 0xff
		glStencilFunc(GL_ALWAYS, GLint(poolIndex!), completeMask)

		var projectionViewMatrix = projectionViewMatrix
		if projectionViewMatrix == nil {
			projectionViewMatrix = EKGLProjectionViewMatrix
		}

		glEnableVertexAttribArray(0)
		glBindBuffer(target: GL_ARRAY_BUFFER,
		             buffer: vertexComponent.bufferID)
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
		             count: vertexComponent.numberOfVertices)
		glDisableVertexAttribArray(0)

		//
		for child in children {
			child.draw(withProjectionViewMatrix: mvp)
		}
	}

	func addChild(child: EKGLObject) {
		children.append(child)
		child.parent = self
	}

	func removeFromParent() {
		guard let parent = parent else { return }

		for (index, sibling) in parent.children.enumerate() {
			if sibling.poolIndex == self.poolIndex {
				parent.children.removeAtIndex(index)
				break
			}
		}

		self.parent = nil
	}
}

class EKGLCube: EKGLObject {
	override init() {
		super.init(vertexComponent: EKGLVertexComponent.Cube)
	}
}

class EKGLCamera {
	static var position = EKVector3.origin()
	static var scale = EKVector3(x: 1, y: 1, z: 1)
	static var rotation = EKVector4(x: 1, y: 0, z: 0, w: 0)

	static var viewMatrix: EKMatrix {
		get {
			let oldCenter = EKVector3(x: 0, y: 0, z: -1)
			let center = rotation.rotate(oldCenter).plus(position)
			let up = rotation.rotate(EKVector3(x: 0, y: 1, z: 0))
			return EKMatrix.createLookAt(eye: position, center: center, up: up)
		}
	}

	static var xAxis: EKVector3 {
		get {
			return rotation.rotate(EKVector3(x: 1, y: 0, z: 0))
		}
	}

	static var yAxis: EKVector3 {
		get {
			return rotation.rotate(EKVector3(x: 0, y: 1, z: 0))
		}
	}

	static var zAxis: EKVector3 {
		get {
			return rotation.rotate(EKVector3(x: 0, y: 0, z: 1))
		}
	}

	static func rotate(rotationObject: AnyObject,
	                   around anchorPoint: AnyObject) {
		// TODO: This doesn't rotate around the anchor
		let orientation = rotation.rotationToQuaternion()

		let rotationOperation = EKVector4.createVector(object: rotationObject)
		let quaternion = rotationOperation.rotationToQuaternion()
			.unitQuaternion()

		let newPosition = quaternion.conjugate(vector: position)
		let newOrientation = quaternion.multiplyAsQuaternion(
			quaternion: orientation)

		position = newPosition.toEKVector3()
		rotation = newOrientation.quaternionToRotation()
	}

	static func rotate(rotationObject: AnyObject) {
		let orientation = rotation.rotationToQuaternion()

		let rotationOperation = EKVector4.createVector(object: rotationObject)
		let quaternion = rotationOperation.rotationToQuaternion()
			.unitQuaternion()

		let newOrientation = quaternion.multiplyAsQuaternion(
			quaternion: orientation)

		rotation = newOrientation.quaternionToRotation()
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
