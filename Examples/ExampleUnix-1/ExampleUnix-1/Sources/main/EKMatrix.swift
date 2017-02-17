// swiftlint:disable variable_name

#if os(Linux)
	import Glibc
#else
	import Darwin
#endif

public struct EKMatrix: EKLanguageCompatible,
CustomStringConvertible, CustomDebugStringConvertible {
	public let m11: Double
	public let m12: Double
	public let m13: Double
	public let m14: Double
	public let m21: Double
	public let m22: Double
	public let m23: Double
	public let m24: Double
	public let m31: Double
	public let m32: Double
	public let m33: Double
	public let m34: Double
	public let m41: Double
	public let m42: Double
	public let m43: Double
	public let m44: Double

	public var debugDescription: String {
		return "<EKMatrix>: [\n \(self.description)]"
	}

	public var description: String {
		return "\(m11) \(m12) \(m13) \(m14)\n\(m21) \(m22) \(m23) \(m24)\n" +
		"\(m31) \(m32) \(m33) \(m34)\n(\(m41) \(m42) \(m43) \(m44)"
	}
}

extension EKMatrix {
	public func times(_ r: EKMatrix) -> EKMatrix {
		let l = self
		return EKMatrix(
			m11: r.m11 * l.m11 + r.m12 * l.m21 + r.m13 * l.m31 + r.m14 * l.m41,
			m12: r.m11 * l.m12 + r.m12 * l.m22 + r.m13 * l.m32 + r.m14 * l.m42,
			m13: r.m11 * l.m13 + r.m12 * l.m23 + r.m13 * l.m33 + r.m14 * l.m43,
			m14: r.m11 * l.m14 + r.m12 * l.m24 + r.m13 * l.m34 + r.m14 * l.m44,
			m21: r.m21 * l.m11 + r.m22 * l.m21 + r.m23 * l.m31 + r.m24 * l.m41,
			m22: r.m21 * l.m12 + r.m22 * l.m22 + r.m23 * l.m32 + r.m24 * l.m42,
			m23: r.m21 * l.m13 + r.m22 * l.m23 + r.m23 * l.m33 + r.m24 * l.m43,
			m24: r.m21 * l.m14 + r.m22 * l.m24 + r.m23 * l.m34 + r.m24 * l.m44,
			m31: r.m31 * l.m11 + r.m32 * l.m21 + r.m33 * l.m31 + r.m34 * l.m41,
			m32: r.m31 * l.m12 + r.m32 * l.m22 + r.m33 * l.m32 + r.m34 * l.m42,
			m33: r.m31 * l.m13 + r.m32 * l.m23 + r.m33 * l.m33 + r.m34 * l.m43,
			m34: r.m31 * l.m14 + r.m32 * l.m24 + r.m33 * l.m34 + r.m34 * l.m44,
			m41: r.m41 * l.m11 + r.m42 * l.m21 + r.m43 * l.m31 + r.m44 * l.m41,
			m42: r.m41 * l.m12 + r.m42 * l.m22 + r.m43 * l.m32 + r.m44 * l.m42,
			m43: r.m41 * l.m13 + r.m42 * l.m23 + r.m43 * l.m33 + r.m44 * l.m43,
			m44: r.m41 * l.m14 + r.m42 * l.m24 + r.m43 * l.m34 + r.m44 * l.m44)
	}

	public func transpose() -> EKMatrix {
		return EKMatrix(m11: m11, m12: m21, m13: m31, m14: m41,
		                m21: m12, m22: m22, m23: m32, m24: m42,
		                m31: m13, m32: m23, m33: m33, m34: m43,
		                m41: m14, m42: m24, m43: m34, m44: m44)
	}
}

extension EKMatrix {
	init() {
		self.init(
			m11: 1, m12: 0, m13: 0, m14: 0,
			m21: 0, m22: 1, m23: 0, m24: 0,
			m31: 0, m32: 0, m33: 1, m34: 0,
			m41: 0, m42: 0, m43: 0, m44: 1)
	}

	init(scale vector: EKVector3) {
		self.init(scaleX: vector.x, y: vector.y, z: vector.z)
	}

	init(scaleX x: Double, y: Double, z: Double) {
		self.init(m11: x, m12: 0, m13: 0, m14: 0,
		          m21: 0, m22: y, m23: 0, m24: 0,
		          m31: 0, m32: 0, m33: z, m34: 0,
		          m41: 0, m42: 0, m43: 0, m44: 1)
	}

	init(translation vector: EKVector3) {
		self.init(translationX: vector.x, y: vector.y, z: vector.z)
	}

	init(translationX x: Double, y: Double, z: Double) {
		self.init(m11: 1, m12: 0, m13: 0, m14: 0,
		          m21: 0, m22: 1, m23: 0, m24: 0,
		          m31: 0, m32: 0, m33: 1, m34: 0,
		          m41: x, m42: y, m43: z, m44: 1)
	}

	init(perspectiveWithYFieldOfView fov: Double,
	     aspect: Double,
	     zNear: Double,
	     zFar: Double) {
		assert(aspect != 0)
		assert(zFar != zNear)

		let tanHalfFov = tan(fov / 2) // 0.557

		self.init(
			m11: 1 / (aspect * tanHalfFov),
			m12: 0, m13: 0, m14: 0, m21: 0,
			m22: 1 / (tanHalfFov),
			m23: 0, m24: 0, m31: 0, m32: 0,
			m33: -(zFar + zNear) / (zFar - zNear),
			m34: -1,
			m41: 0, m42: 0,
			m43: -(2 * zFar * zNear) / (zFar - zNear),
			m44: 0)
	}

	init(lookAtWithEye eye: EKVector3,
	     center: EKVector3,
	     up: EKVector3) {
		let f = center.minus(eye).normalize()
		let s = f.cross(up).normalize()
		let u = s.cross(f)

		self.init(
			m11: s.x, m12: u.x, m13: -f.x, m14: 0,
			m21: s.y, m22: u.y, m23: -f.y, m24: 0,
			m31: s.z, m32: u.z, m33: -f.z, m34: 0,
			m41: -s.dot(eye),
			m42: -u.dot(eye),
			m43:  f.dot(eye), m44: 1)
	}
}

extension EKMatrix {
	public func times(_ v: EKVector4) -> EKVector4 {
		let m = self
		return EKVector4(
			x: v.x * m.m11 + v.y * m.m12 + v.z * m.m13 + v.w * m.m14,
			y: v.x * m.m21 + v.y * m.m22 + v.z * m.m23 + v.w * m.m24,
			z: v.x * m.m31 + v.y * m.m32 + v.z * m.m33 + v.w * m.m34,
			w: v.x * m.m41 + v.y * m.m42 + v.z * m.m43 + v.w * m.m44)
	}
}
