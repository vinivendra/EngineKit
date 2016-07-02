import SGLOpenGL

var EKGLMVPMatrixID: GLint! = nil
var EKGLColorID: GLint! = nil
var EKGLProjectionViewMatrix = EKMatrix.identity

var EKGLObjectPool = EKResourcePool<EKGLObject>()

public class EKGLObject: EKGLMatrixComposer {
	var poolIndex: Int? = nil

	var matrixComponent = EKGLMatrixComponent()
	let vertexComponent: EKGLVertexComponent?

	var color: EKColorType? = nil

	var name: String? = nil

	var children = [EKGLObject]()
	var parent: EKGLObject? = nil

	internal init(vertexComponent: EKGLVertexComponent?) {
		self.vertexComponent = vertexComponent

		if poolIndex == nil {
			poolIndex = EKGLObjectPool.addResourceAndGetIndex(self)
		}
	}

	public convenience init() {
		self.init(vertexComponent: nil)
	}
}

extension EKGLObject {
	public static func object(atPixel pixel: EKVector2) -> EKGLObject? {
		var index: GLuint = 0
		let x = GLint(pixel.x) * 2
		let y = GLint(pixel.y) * 2
		glReadPixels(x, y, 1, 1,
		             GL_STENCIL_INDEX, GL_UNSIGNED_INT, &index);
		return EKGLObjectPool[Int(index)]
	}
}

extension EKGLObject {
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
}

extension EKGLObject {
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

extension EKGLObject {
	func rotate(rotationObject: AnyObject,
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

	func rotate(rotationObject: AnyObject) {
		let orientation = rotation.rotationToQuaternion()

		let rotationOperation = EKVector4.createVector(object: rotationObject)
		let quaternion = rotationOperation.rotationToQuaternion()
			.unitQuaternion()

		let newOrientation = quaternion.multiplyAsQuaternion(
			quaternion: orientation)

		rotation = newOrientation.quaternionToRotation()
	}
}

class EKGLCube: EKGLObject {
	init() {
		super.init(vertexComponent: EKGLVertexComponent.Cube)
	}
}

class EKGLCamera: EKGLObject {
	static var mainCamera = EKGLCamera()

	var viewMatrix: EKMatrix {
		get {
			let oldCenter = EKVector3(x: 0, y: 0, z: -1)
			let center = rotation.rotate(oldCenter).plus(position)
			let up = rotation.rotate(EKVector3(x: 0, y: 1, z: 0))
			return EKMatrix.createLookAt(eye: position, center: center, up: up)
		}
	}

	var xAxis: EKVector3 {
		get {
			return rotation.rotate(EKVector3(x: 1, y: 0, z: 0))
		}
	}

	var yAxis: EKVector3 {
		get {
			return rotation.rotate(EKVector3(x: 0, y: 1, z: 0))
		}
	}

	var zAxis: EKVector3 {
		get {
			return rotation.rotate(EKVector3(x: 0, y: 0, z: 1))
		}
	}
}
