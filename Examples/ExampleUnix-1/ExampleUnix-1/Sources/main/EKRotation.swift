// swiftlint:disable variable_name

#if os(Linux)
	import Glibc
#else
	import Darwin
#endif

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

	init(x: Double, y: Double, z: Double, w: Double) {
		let normSquared = x * x + y * y + z * z + w * w
		let norm = sqrt(normSquared)
		if norm == 0 {
			self.x = x
			self.y = y
			self.z = z
			self.w = w
		} else {
			self.x = x / norm
			self.y = y / norm
			self.z = z / norm
			self.w = w / norm
		}
	}
}

extension EKRotation {
	public init(literalX x: Double, y: Double, z: Double, w: Double) {
		self.x = x
		self.y = y
		self.z = z
		self.w = w
	}

	init() {
		self.init(literalX: 0, y: 0, z: 0, w: 1)
	}

	init(representing vector: EKVector4) {
		self.init(literalX: vector.x,
		          y: vector.y,
		          z: vector.z,
		          w: vector.w)
	}

	init(_ rotation: EKRotation) {
		self.init(literalX: rotation.x,
		          y: rotation.y,
		          z: rotation.z,
		          w: rotation.w)
	}

	init(axis: EKVector3, angle: Double) {
		let halfAngle = angle / 2
		let cosine = cos(halfAngle)
		let sine = sin(halfAngle)
		self.init(x: sine * axis.x,
		          y: sine * axis.y,
		          z: sine * axis.z,
		          w: cosine)
	}

	init(_ array: [Double]) {
		let axis = EKVector3(array)
		self.init(axis: axis,
		          angle: array[zero: 3])
	}

	init(_ dictionary: [String: Double]) {
		let axis = EKVector3(dictionary)
		self.init(axis: axis,
		          angle: dictionary[zero: ["3", "w", "W", "a", "A"]])
	}

	init(_ string: String) {
		var strings = [string]

		let separators: [UnicodeScalar] = [",", " ", "[", "]", "{", "}"]
		for separator in separators {
			strings = strings.flatMap({
				$0.split(character: separator)
			})
		}

		let doubles = strings.flatMap(Double.init)

		self.init(doubles)
	}

	init?(fromValue value: Any) {
		if let rotation = value as? EKRotation {
			self.init(rotation)
		} else if let array = value as? [Double] {
			self.init(array)
		} else if let string = value as? String {
			self.init(string)
		} else if let dictionary = value as? [String: Double] {
			self.init(dictionary)
		} else {
			return nil
		}
	}
}

extension EKRotation {
	public func toEKVector3() -> EKVector3 {
		return EKVector3(x: x, y: y, z: z)
	}

	public func times(_ q: EKRotation) -> EKRotation {
		return EKRotation(
			literalX:
			self.w * q.x + self.x * q.w + self.y * q.z - self.z * q.y, y:
			self.w * q.y + self.y * q.w - self.x * q.z + self.z * q.x, z:
			self.w * q.z + self.z * q.w + self.x * q.y - self.y * q.x, w:
			self.w * q.w - self.x * q.x - self.y * q.y - self.z * q.z)
	}

	public func normSquared() -> Double {
		return x*x + y*y + z*z + w*w
	}

	public func norm() -> Double {
		return sqrt(self.normSquared())
	}

	public func normalized() -> EKRotation {
		let norm = self.norm()
		if norm == 0 {
			return self
		} else {
			return EKRotation(x: x / norm,
			                  y: y / norm,
			                  z: z / norm,
			                  w: w / norm)
		}
	}

	public func opposite() -> EKRotation {
		return EKRotation(literalX: -x, y: -y, z: -z, w: w)
	}

	func conjugate(vector: EKVector4) -> EKRotation {
		return self.conjugate(quaternion: vector.toRotation())
	}

	func conjugate(quaternion: EKRotation) -> EKRotation {
		return self.times(quaternion.times(self.opposite()))
	}

	public func rotate(_ v: EKVector3) -> EKVector3 {
		return self.conjugate(vector: v.toHomogeneousVector()).toEKVector3()
	}

	public func rotate(matrix: EKMatrix) -> EKMatrix {
		return self.toMatrix().times(matrix)
	}

	public func toMatrix() -> EKMatrix {
		return EKMatrix(m11: 1 - 2*y*y - 2*z*z,
		                m12: 2*x*y - 2*z*w,
		                m13: 2*x*z + 2*y*w, m14: 0,
		                m21: 2*x*y + 2*z*w,
		                m22: 1 - 2*x*x - 2*z*z,
		                m23: 2*y*z - 2*x*w, m24: 0,
		                m31: 2*x*z - 2*y*w,
		                m32: 2*y*z + 2*x*w,
		                m33: 1 - 2*x*x - 2*y*y, m34: 0,
		                m41: 0, m42: 0, m43: 0, m44: 1)
	}

	public func toAxisRotation() -> (axis: EKVector3, angle: Double) {
		let s = sqrt(1 - w * w)
		if s < 0.0001 {
			return (axis: EKVector3(x: 1, y: 1, z: 1),
			        angle: 0)
		} else {
			return (axis: EKVector3(x: x / s,
			                        y: y / s,
			                        z: z / s),
			        angle: 2 * acos(w))
		}
	}

	public func toArray() -> [Double] {
		let (axis, angle) = self.toAxisRotation()
		var result = axis.toArray()
		result.append(angle)
		return result
	}
}

public func == (lhs: EKRotation, rhs: EKRotation) -> Bool {
	return lhs.x == rhs.x && lhs.y == rhs.y &&
		lhs.z == rhs.z && lhs.w == rhs.w
}

public func != (lhs: EKRotation, rhs: EKRotation) -> Bool {
	return !(lhs == rhs)
}
