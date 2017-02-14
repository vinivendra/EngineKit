// swiftlint:disable variable_name

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

public struct EKRotation: EKLanguageCompatible,
CustomStringConvertible, CustomDebugStringConvertible {
	public let x: Double
	public let y: Double
	public let z: Double
	public let w: Double

	public var debugDescription: String {
		return "<EKRotation> " + self.description
	}

	public var description: String {
		return "x: \(x), y: \(y), z: \(z), w: \(w)"
	}
}

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
