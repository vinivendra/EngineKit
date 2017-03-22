import SwiftGL

extension EKMatrix {
	public func withGLFloatArray<ReturnType>(
		closure: (UnsafePointer<GLfloat>) -> ReturnType) -> ReturnType {

		let array: [GLfloat] =
			[GLfloat(m11), GLfloat(m12), GLfloat(m13), GLfloat(m14),
			 GLfloat(m21), GLfloat(m22), GLfloat(m23), GLfloat(m24),
			 GLfloat(m31), GLfloat(m32), GLfloat(m33), GLfloat(m34),
			 GLfloat(m41), GLfloat(m42), GLfloat(m43), GLfloat(m44)]
		return array.withUnsafeBufferPointer {
			return closure($0.baseAddress!)
		}
	}
}

extension EKColor {
	public func withGLFloatArray<ReturnType>(
		closure: @escaping (UnsafePointer<GLfloat>) -> ReturnType) -> ReturnType
	{

		let array = self.toArray().map { GLfloat($0) }
		return array.withUnsafeBufferPointer {
			return closure($0.baseAddress!)
		}
	}
}

extension EKVector3 {
	public func withGLFloatArray<ReturnType>(
		closure: @escaping (UnsafePointer<GLfloat>) -> ReturnType) -> ReturnType
	{

		let array = self.toArray().map { GLfloat($0) }
		return array.withUnsafeBufferPointer {
			return closure($0.baseAddress!)
		}
	}
}
