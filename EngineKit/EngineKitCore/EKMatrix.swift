public protocol EKMatrixType: class,
	EKLanguageCompatible,
	CustomDebugStringConvertible,
	CustomStringConvertible {

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

@warn_unused_result
public func * (v: EKVector4, m: EKMatrix) -> EKVector4 {
	return EKVector4(x: v.x * m.m11 + v.y * m.m21 + v.z * m.m31 + v.w * m.m41,
	                 y: v.x * m.m12 + v.y * m.m22 + v.z * m.m32 + v.w * m.m42,
	                 z: v.x * m.m13 + v.y * m.m23 + v.z * m.m33 + v.w * m.m43,
	                 w: v.x * m.m14 + v.y * m.m24 + v.z * m.m34 + v.w * m.m44)
}
