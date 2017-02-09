// swiftlint:disable variable_name

public struct EKVector2: EKLanguageCompatible,
CustomStringConvertible, CustomDebugStringConvertible {

	public let x: Double
	public let y: Double

	public var debugDescription: String {
		return "<EKVector2> " + self.description
	}

	public var description: String {
		return "x: \(x), y: \(y)"
	}
}

public struct EKVector3: EKLanguageCompatible,
CustomStringConvertible, CustomDebugStringConvertible {

	public let x: Double
	public let y: Double
	public let z: Double

	public var debugDescription: String {
		return "<EKVector3> " + self.description
	}

	public var description: String {
		return "x: \(x), y: \(y), z: \(z)"
	}
}

public struct EKVector4: EKLanguageCompatible,
CustomStringConvertible, CustomDebugStringConvertible {
	public let x: Double
	public let y: Double
	public let z: Double
	public let w: Double

	public var debugDescription: String {
		return "<EKVector4> " + self.description
	}

	public var description: String {
		return "x: \(x), y: \(y), z: \(z), w: \(w)"
	}
}

public final class EKRotation: EKRotationType, EKLanguageCompatible {
	public let x: Double
	public let y: Double
	public let z: Double
	public let w: Double

	init(x: Double, y: Double, z: Double, w: Double) {
		self.x = x
		self.y = y
		self.z = z
		self.w = w
	}

	public static func createRotation(x: Double,
	                                  y: Double,
	                                  z: Double,
	                                  w: Double) -> EKRotation {
		return EKRotation(x: x, y: y, z: z, w: w)
	}

	public var debugDescription: String {
		return "x: \(x), y: \(y), z: \(z), w: \(w)"
	}

	public var description: String {
		return debugDescription
	}
}

public class EKMatrix: EKMatrixType, EKLanguageCompatible {
	// swiftlint:disable:next function_parameter_count
	public static func createMatrix(
		m11: Double, m12: Double, m13: Double, m14: Double,
		m21: Double, m22: Double, m23: Double, m24: Double,
		m31: Double, m32: Double, m33: Double, m34: Double,
		m41: Double, m42: Double, m43: Double, m44: Double) -> EKMatrix {
		return EKMatrix(m11: m11, m12: m12, m13: m13, m14: m14,
		                m21: m21, m22: m22, m23: m23, m24: m24,
		                m31: m31, m32: m32, m33: m33, m34: m34,
		                m41: m41, m42: m42, m43: m43, m44: m44)
	}

	// swiftlint:disable:next function_parameter_count
	init(m11: Double, m12: Double, m13: Double, m14: Double,
	     m21: Double, m22: Double, m23: Double, m24: Double,
	     m31: Double, m32: Double, m33: Double, m34: Double,
	     m41: Double, m42: Double, m43: Double, m44: Double) {
		self.m11 = m11
		self.m12 = m12
		self.m13 = m13
		self.m14 = m14
		self.m21 = m21
		self.m22 = m22
		self.m23 = m23
		self.m24 = m24
		self.m31 = m31
		self.m32 = m32
		self.m33 = m33
		self.m34 = m34
		self.m41 = m41
		self.m42 = m42
		self.m43 = m43
		self.m44 = m44
	}

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
		return "((\(m11) \(m12) \(m13) \(m14)) (\(m21) \(m22) \(m23) \(m24))" +
		"(\(m31) \(m32) \(m33) \(m34)) (\(m41) \(m42) \(m43) \(m44)))"
	}

	public var description: String {
		return debugDescription
	}
}
