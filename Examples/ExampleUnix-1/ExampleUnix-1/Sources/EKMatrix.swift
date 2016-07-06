import Darwin

let EKUsesOpenGLOrientedMath = true

public protocol EKMatrixType: class,
EKLanguageCompatible {

	static func createMatrix(
		m11: Double, m12: Double, m13: Double, m14: Double,
		m21: Double, m22: Double, m23: Double, m24: Double,
		m31: Double, m32: Double, m33: Double, m34: Double,
		m41: Double, m42: Double, m43: Double, m44: Double) -> EKMatrix

	var m11: Double { get }
	var m12: Double { get }
	var m13: Double { get }
	var m14: Double { get }
	var m21: Double { get }
	var m22: Double { get }
	var m23: Double { get }
	var m24: Double { get }
	var m31: Double { get }
	var m32: Double { get }
	var m33: Double { get }
	var m34: Double { get }
	var m41: Double { get }
	var m42: Double { get }
	var m43: Double { get }
	var m44: Double { get }
}

@warn_unused_result
public func * (l: EKMatrix, r: EKMatrix) -> EKMatrix {
	return EKUsesOpenGLOrientedMath ? r.times(l) : l.times(r)
}

@warn_unused_result
public func * (v: EKVector4, m: EKMatrix) -> EKVector4 {
	return EKVector4(x: v.x * m.m11 + v.y * m.m21 + v.z * m.m31 + v.w * m.m41,
	                 y: v.x * m.m12 + v.y * m.m22 + v.z * m.m32 + v.w * m.m42,
	                 z: v.x * m.m13 + v.y * m.m23 + v.z * m.m33 + v.w * m.m43,
	                 w: v.x * m.m14 + v.y * m.m24 + v.z * m.m34 + v.w * m.m44)
}

@warn_unused_result
public func * (m: EKMatrix, v: EKVector4) -> EKVector4 {
	return EKVector4(x: v.x * m.m11 + v.y * m.m12 + v.z * m.m13 + v.w * m.m14,
	                 y: v.x * m.m21 + v.y * m.m22 + v.z * m.m23 + v.w * m.m24,
	                 z: v.x * m.m31 + v.y * m.m32 + v.z * m.m33 + v.w * m.m34,
	                 w: v.x * m.m41 + v.y * m.m42 + v.z * m.m43 + v.w * m.m44)
}

extension EKMatrix {
	public static func identity() -> EKMatrix {
		return EKMatrix.createMatrix(
			m11: 1, m12: 0, m13: 0, m14: 0,
			m21: 0, m22: 1, m23: 0, m24: 0,
			m31: 0, m32: 0, m33: 1, m34: 0,
			m41: 0, m42: 0, m43: 0, m44: 1)
	}

	public func times(_ r: EKMatrix) -> EKMatrix {
		let l = self
		return EKMatrix(
			m11: l.m11 * r.m11 + l.m12 * r.m21 + l.m13 * r.m31 + l.m14 * r.m41,
			m12: l.m11 * r.m12 + l.m12 * r.m22 + l.m13 * r.m32 + l.m14 * r.m42,
			m13: l.m11 * r.m13 + l.m12 * r.m23 + l.m13 * r.m33 + l.m14 * r.m43,
			m14: l.m11 * r.m14 + l.m12 * r.m24 + l.m13 * r.m34 + l.m14 * r.m44,
			m21: l.m21 * r.m11 + l.m22 * r.m21 + l.m23 * r.m31 + l.m24 * r.m41,
			m22: l.m21 * r.m12 + l.m22 * r.m22 + l.m23 * r.m32 + l.m24 * r.m42,
			m23: l.m21 * r.m13 + l.m22 * r.m23 + l.m23 * r.m33 + l.m24 * r.m43,
			m24: l.m21 * r.m14 + l.m22 * r.m24 + l.m23 * r.m34 + l.m24 * r.m44,
			m31: l.m31 * r.m11 + l.m32 * r.m21 + l.m33 * r.m31 + l.m34 * r.m41,
			m32: l.m31 * r.m12 + l.m32 * r.m22 + l.m33 * r.m32 + l.m34 * r.m42,
			m33: l.m31 * r.m13 + l.m32 * r.m23 + l.m33 * r.m33 + l.m34 * r.m43,
			m34: l.m31 * r.m14 + l.m32 * r.m24 + l.m33 * r.m34 + l.m34 * r.m44,
			m41: l.m41 * r.m11 + l.m42 * r.m21 + l.m43 * r.m31 + l.m44 * r.m41,
			m42: l.m41 * r.m12 + l.m42 * r.m22 + l.m43 * r.m32 + l.m44 * r.m42,
			m43: l.m41 * r.m13 + l.m42 * r.m23 + l.m43 * r.m33 + l.m44 * r.m43,
			m44: l.m41 * r.m14 + l.m42 * r.m24 + l.m43 * r.m34 + l.m44 * r.m44)
	}
}

extension EKMatrix {
	public static func createScale(_ vector: EKVector3) -> EKMatrix {
		return createScale(x: vector.x, y: vector.y, z: vector.z)
	}

	public static func createScale(x: Double, y: Double, z: Double)
		-> EKMatrix {
			return EKMatrix.createMatrix(m11: x, m12: 0, m13: 0, m14: 0,
			                             m21: 0, m22: y, m23: 0, m24: 0,
			                             m31: 0, m32: 0, m33: z, m34: 0,
			                             m41: 0, m42: 0, m43: 0, m44: 1)
	}

	public static func createTranslation(_ vector: EKVector3) -> EKMatrix {
		return createTranslation(x: vector.x, y: vector.y, z: vector.z)
	}

	public static func createTranslation(x: Double, y: Double, z: Double)
		-> EKMatrix {
			if EKUsesOpenGLOrientedMath {
				return EKMatrix.createMatrix(m11: 1, m12: 0, m13: 0, m14: 0,
				                             m21: 0, m22: 1, m23: 0, m24: 0,
				                             m31: 0, m32: 0, m33: 1, m34: 0,
				                             m41: x, m42: y, m43: z, m44: 1)
			} else {
				return EKMatrix.createMatrix(m11: 1, m12: 0, m13: 0, m14: x,
				                             m21: 0, m22: 1, m23: 0, m24: y,
				                             m31: 0, m32: 0, m33: 1, m34: z,
				                             m41: 0, m42: 0, m43: 0, m44: 1)
			}
	}

	public static func createPerspective(fieldOfViewY fov: Double,
	                                     aspect: Double,
	                                     zNear: Double,
	                                     zFar: Double) -> EKMatrix {
		assert(aspect != 0)
		assert(zFar != zNear)

		let tanHalfFov = tan(fov / 2) // 0.557

		let result = EKMatrix.createMatrix(
			m11: 1 / (aspect * tanHalfFov),
			m12: 0, m13: 0, m14: 0, m21: 0,
			m22: 1 / (tanHalfFov),
			m23: 0, m24: 0, m31: 0, m32: 0,
			m33: -(zFar + zNear) / (zFar - zNear),
			m34: -1,
			m41: 0, m42: 0,
			m43: -(2 * zFar * zNear) / (zFar - zNear),
			m44: 0)

		return EKUsesOpenGLOrientedMath ? result : result.transpose()
	}

	public static func createLookAt(eye: EKVector3,
	                                center: EKVector3,
	                                up: EKVector3) -> EKMatrix {
		let f = center.minus(eye).normalize()
		let s = f.cross(up).normalize()
		let u = s.cross(f)

		let result = EKMatrix.createMatrix(
			m11: s.x, m12: u.x, m13: -f.x, m14: 0,
			m21: s.y, m22: u.y, m23: -f.y, m24: 0,
			m31: s.z, m32: u.z, m33: -f.z, m34: 0,
			m41: -s.dot(eye),
			m42: -u.dot(eye),
			m43:  f.dot(eye), m44: 1)
		return EKUsesOpenGLOrientedMath ? result : result.transpose()
	}
}

extension EKMatrix {
	public func transpose() -> EKMatrix {
		return EKMatrix.createMatrix(m11: m11, m12: m21, m13: m31, m14: m41,
		                             m21: m12, m22: m22, m23: m32, m24: m42,
		                             m31: m13, m32: m23, m33: m33, m34: m43,
		                             m41: m14, m42: m24, m43: m34, m44: m44)
	}
}
