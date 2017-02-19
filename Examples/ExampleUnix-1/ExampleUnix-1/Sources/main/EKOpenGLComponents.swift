import SwiftGL

public struct EKGLMatrixComponent {
	public var position = EKVector3() {
		didSet {
			_modelMatrix = nil
		}
	}
	public var scale = EKVector3(x: 1, y: 1, z: 1) {
		didSet {
			_modelMatrix = nil
		}
	}
	public var rotation = EKRotation(x: 0, y: 0, z: 0, w: 1) {
		didSet {
			_modelMatrix = nil
		}
	}

	private var _modelMatrix: EKMatrix? = nil

	public mutating func getMatrix() -> EKMatrix {
		guard let modelMatrix = _modelMatrix else {
			_modelMatrix = position.translationToMatrix().times(
				scale.scaleToMatrix().times(
				rotation.toMatrix()))
			return _modelMatrix!
		}
		return modelMatrix
	}

	init () { }
}

protocol EKGLMatrixComposer: class {
	var matrixComponent: EKGLMatrixComponent { get set }
	var position: EKVector3 { get set }
	var scale: EKVector3 { get set }
	var rotation: EKRotation { get set }
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

	var rotation: EKRotation {
		get {
			return matrixComponent.rotation
		}
		set {
			matrixComponent.rotation = newValue
		}
	}

	var modelMatrix: EKMatrix {
		return matrixComponent.getMatrix()
	}
}

public struct EKGLVertexComponent {
	private let vertices: [GLfloat]

	public let bufferID: GLuint
	public let numberOfVertices: GLsizei

	public let meshName: String

	public init(meshName: String, vertices: [GLfloat]) {
		self.vertices = vertices
		self.numberOfVertices = GLsizei(vertices.count) / 3

		self.meshName = meshName

		var tempBufferID: GLuint = 0
		glGenBuffers(n: 1, buffers: &tempBufferID)
		glBindBuffer(target: GL_ARRAY_BUFFER, buffer: tempBufferID)
		glBufferData(target: GL_ARRAY_BUFFER,
		             size: MemoryLayout<[GLfloat]>.size * vertices.count,
		             data: vertices,
		             usage: GL_DYNAMIC_DRAW)
		self.bufferID = tempBufferID
	}

	public init(fromFile filename: String) {
		var rawVertices = [[GLfloat]]()
		var vertices = [GLfloat]()

		let fileManager = OSFactory.createFileManager()
		let fileContents = fileManager.getContentsFromFile("../../" + filename)!

		for match in fileContents =~ "v ([^\\s]+) ([^\\s]+) ([^\\s]+)" {
			rawVertices.append([GLfloat(match.getMatch(atIndex: 1)!)!,
			                    GLfloat(match.getMatch(atIndex: 2)!)!,
			                    GLfloat(match.getMatch(atIndex: 3)!)!])
		}

		let vertex = "([^/]+)/[^\\s]+"
		for match in fileContents =~ "f \(vertex) \(vertex) \(vertex)" {
			let index1 = Int(match.getMatch(atIndex: 1)!)! - 1
			let index2 = Int(match.getMatch(atIndex: 2)!)! - 1
			let index3 = Int(match.getMatch(atIndex: 3)!)! - 1
			vertices.append(contentsOf: rawVertices[index1])
			vertices.append(contentsOf: rawVertices[index2])
			vertices.append(contentsOf: rawVertices[index3])
			print(index1)
			print(index2)
			print(index3)
		}

		let meshName = filename.split(character: ".").first!

		self.init(meshName: meshName, vertices: vertices)
	}

	//
	public enum GeometricComponent: String {
		case cube
	}

	public static func component(forGeometryNamed string: String)
		-> EKGLVertexComponent?
	{
		guard let geometry = GeometricComponent(rawValue: string)
			else {
				return nil
		}
		return component(forGeometry: geometry)
	}

	public static func component(forGeometry geometry: GeometricComponent)
		-> EKGLVertexComponent
	{
		switch geometry {
		case .cube:
			return EKGLVertexComponent.Cube
		}
	}

	//
	public static let Cube = EKGLVertexComponent(fromFile: "cube.obj")
//		EKGLVertexComponent(
//		meshName: "cube",
//		vertices: [
//			-1.0, -1.0, -1.0,
//			-1.0, -1.0, 1.0,
//			-1.0, 1.0, 1.0,
//			1.0, 1.0, -1.0,
//			-1.0, -1.0, -1.0,
//			-1.0, 1.0, -1.0,
//			1.0, -1.0, 1.0,
//			-1.0, -1.0, -1.0,
//			1.0, -1.0, -1.0,
//			1.0, 1.0, -1.0,
//			1.0, -1.0, -1.0,
//			-1.0, -1.0, -1.0,
//			-1.0, -1.0, -1.0,
//			-1.0, 1.0, 1.0,
//			-1.0, 1.0, -1.0,
//			1.0, -1.0, 1.0,
//			-1.0, -1.0, 1.0,
//			-1.0, -1.0, -1.0,
//			-1.0, 1.0, 1.0,
//			-1.0, -1.0, 1.0,
//			1.0, -1.0, 1.0,
//			1.0, 1.0, 1.0,
//			1.0, -1.0, -1.0,
//			1.0, 1.0, -1.0,
//			1.0, -1.0, -1.0,
//			1.0, 1.0, 1.0,
//			1.0, -1.0, 1.0,
//			1.0, 1.0, 1.0,
//			1.0, 1.0, -1.0,
//			-1.0, 1.0, -1.0,
//			1.0, 1.0, 1.0,
//			-1.0, 1.0, -1.0,
//			-1.0, 1.0, 1.0,
//			1.0, 1.0, 1.0,
//			-1.0, 1.0, 1.0,
//			1.0, -1.0, 1.0
//		])
}
