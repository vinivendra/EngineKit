import SwiftGL

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
		             size: MemoryLayout<[GLfloat]>.size * vertices.count,
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

