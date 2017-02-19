import SwiftGL

public class EKGLObject: EKGLMatrixComposer {
	public static var mvpMatrixID: GLint! = nil
	public static var colorID: GLint! = nil
	public static var projectionViewMatrix = EKMatrix()

	public static var allObjects = EKResourcePool<EKGLObject>()

	fileprivate(set) public var objectID: Int? = nil

	public var matrixComponent: EKGLMatrixComponent = EKGLMatrixComponent()
	public var vertexComponent: EKGLVertexComponent?
	public var physicsComponent: EKPhysicsComponent? = nil

	public var color: EKColor = EKColor.whiteColor()

	public var name: String? = nil

	public var children = [EKGLObject]()
	public var parent: EKGLObject? = nil

	//
	internal init(vertexComponent: EKGLVertexComponent?) {
		self.vertexComponent = vertexComponent

		if objectID == nil {
			objectID = EKGLObject.allObjects.addResourceAndGetIndex(self)
		}
	}

	public convenience init() {
		self.init(vertexComponent: nil)
	}

	deinit {
		self.destroy()
	}

	//
	public func setupPhysicsComponent() {
		self.physicsComponent =
			ekPhysicsAddon?.createPhysicsComponent(fromObject: self)
	}

	//
	public func copyInfo(to object: EKGLObject) {
		object.matrixComponent = matrixComponent
		object.physicsComponent = physicsComponent
		object.color = color
		object.name = name

		for child in children {
			object.addChild(child.copy())
		}
	}
}

extension EKGLObject {
	public static func object(withID objectID: Int) -> EKGLObject? {
		return EKGLObject.allObjects[objectID]
	}
}

extension EKGLObject {
	public func copy() -> EKGLObject {
		let object = EKGLObject(vertexComponent: vertexComponent)
		copyInfo(to: object)
		return object
	}

	public func destroy() {
		self.removeFromParent()

		if let objectID = objectID {
			EKGLObject.allObjects.deleteResource(atIndex: objectID)
			self.objectID = nil
		}
	}
}

extension EKGLObject {
	public static func object(atPixel pixel: EKVector2) -> EKGLObject? {
		var index: GLuint = 0
		let x = GLint(pixel.x)
		let y = GLint(pixel.y)
		glReadPixels(x, y, 1, 1,
		             GL_STENCIL_INDEX, GL_UNSIGNED_INT, &index)
		return EKGLObject.allObjects[Int(index)]
	}
}

extension EKGLObject {
	func draw(withProjectionViewMatrix projectionViewMatrix: EKMatrix! = nil) {
		guard let vertexComponent = vertexComponent else { return }

		//
		let completeMask: GLuint = 0xff
		glStencilFunc(GL_ALWAYS, GLint(objectID!), completeMask)

		let projectionViewMatrix = projectionViewMatrix ??
			EKGLObject.projectionViewMatrix

		glEnableVertexAttribArray(0)
		glBindBuffer(target: GL_ARRAY_BUFFER,
		             buffer: vertexComponent.bufferID)
		glVertexAttribPointer(
			index: 0, // Matching shader
			size: 3,
			type: GL_FLOAT,
			normalized: false,
			stride: 0,
			pointer: NULL) // offset

		//
		let mvp = projectionViewMatrix.times(modelMatrix)

		mvp.withGLFloatArray {
			glUniformMatrix4fv(location: EKGLObject.mvpMatrixID,
			                   count: 1,
			                   transpose: false,
			                   value: $0)
		}

		color.withGLFloatArray {
			glUniform3fv(location: EKGLObject.colorID,
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
}

extension EKGLObject {
	func addChild(_ child: EKGLObject) {
		children.append(child)
		child.parent = self
	}

	func removeFromParent() {
		guard let parent = parent else { return }

		for (index, sibling) in parent.children.enumerated() {
			if sibling.objectID == self.objectID {
				parent.children.remove(at: index)
				break
			}
		}

		self.parent = nil
	}
}

extension EKGLObject {
	func rotate(_ rotationObject: Any,
	            around anchorPoint: Any) {
		// FIXME: This doesn't rotate around the anchor
		let rotationOperation = EKRotation(fromValue: rotationObject)!
		let quaternion = rotationOperation.normalized()

		let newPosition = quaternion.conjugate(vector:
			position.toHomogeneousVector())
		let newRotation = quaternion.times(rotation)

		position = newPosition.toEKVector3()
		rotation = newRotation
	}

	func rotate(_ rotationObject: Any) {
		let rotationOperation = EKRotation(fromValue: rotationObject)!
		let quaternion = rotationOperation.normalized()

		let newRotation = quaternion.times(rotation)

		rotation = newRotation
	}
}

public class EKGLCube: EKGLObject {
	public init() {
		super.init(vertexComponent: EKGLVertexComponent.Cube)
	}

	override public func copyInfo(to object: EKGLObject) {
		super.copyInfo(to: object)
		object.vertexComponent = EKGLVertexComponent.Cube
	}
}

class EKGLCamera: EKGLObject {
	static var mainCamera = EKGLCamera()

	var viewMatrix: EKMatrix {
		let oldCenter = EKVector3(x: 0, y: 0, z: -1)
		let center = rotation.rotate(oldCenter).plus(position)
		let up = rotation.rotate(EKVector3(x: 0, y: 1, z: 0))
		return EKMatrix(lookAtWithEye: position, center: center, up: up)
	}

	var xAxis: EKVector3 {
		return rotation.rotate(EKVector3(x: 1, y: 0, z: 0))
	}

	var yAxis: EKVector3 {
		return rotation.rotate(EKVector3(x: 0, y: 1, z: 0))
	}

	var zAxis: EKVector3 {
		return rotation.rotate(EKVector3(x: 0, y: 0, z: 1))
	}
}
