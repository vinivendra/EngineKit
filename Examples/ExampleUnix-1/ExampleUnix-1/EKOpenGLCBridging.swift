import SGLOpenGL

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