// swiftlint:disable variable_name

#if os(Linux)
	import Glibc
#else
	import Darwin
#endif

public func == (lhs: EKRotation, rhs: EKRotation) -> Bool {
	if lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z && lhs.w == rhs.w {
		return true
	}
	let lUnit = lhs.normalized()
	let rUnit = rhs.normalized()
	return lUnit.x == rUnit.x && lUnit.y == rUnit.y &&
		lUnit.z == rUnit.z && lUnit.w == rUnit.w
}

public func != (lhs: EKRotation, rhs: EKRotation) -> Bool {
	return !(lhs == rhs)
}

public func * (lhs: EKRotation, rhs: EKRotation) -> EKRotation {
	return lhs.times(rhs)
}

extension EKRotation {
	static func createRotation(axis: EKVector3,
	                           angle: Double) -> EKRotation {
		let halfAngle = angle / 2
		let cosine = cos(halfAngle)
		let sine = sin(halfAngle)
		return EKRotation(x: sine * axis.x,
		                  y: sine * axis.y,
		                  z: sine * axis.z,
		                  w: cosine)
	}

	public static func createRotation(fromArray array: [Double]) -> EKRotation {
		let axis = EKVector3(fromArray: array)
		return EKRotation.createRotation(axis: axis,
		                                 angle: array[zero: 3])
	}

	public static func createRotation(fromDictionary
		dictionary: [String: Double]) -> EKRotation
	{
		let axis = EKVector3(fromDictionary: dictionary)
		return EKRotation.createRotation(
			axis: axis,
			angle: dictionary[zero: ["3", "w", "W", "a", "A"]])
	}

	public static func createRotation(fromString string: String) -> EKRotation {
		var strings = [string]

		let separators: [UnicodeScalar] = [",", " ", "[", "]", "{", "}"]
		for separator in separators {
			strings = strings.flatMap({
				$0.split(character: separator)
			})
		}

		let doubles = strings.flatMap(Double.init)

		return EKRotation.createRotation(fromArray: doubles)
	}

	public static func createRotation(fromObject
		object: Any) -> EKRotation {

		if let rotation = object as? EKRotation {
			return rotation
		} else if let array = object as? [Double] {
			return EKRotation.createRotation(fromArray: array)
		} else if let string = object as? String {
			return EKRotation.createRotation(fromString: string)
		} else if let dictionary = object as? [String: Double] {
			return EKRotation.createRotation(fromDictionary: dictionary)
		}

		return nullRotation()
	}

	public static func nullRotation() -> EKRotation {
		return EKRotation(x: 0, y: 0, z: 0, w: 1)
	}
}

extension EKRotation {
	public func toEKVector3() -> EKVector3 {
		return EKVector3(x: x, y: y, z: z)
	}

	public func times(_ q: EKRotation) -> EKRotation {
		return EKRotation(
			x: self.w * q.x + self.x * q.w + self.y * q.z - self.z * q.y,
			y: self.w * q.y + self.y * q.w - self.x * q.z + self.z * q.x,
			z: self.w * q.z + self.z * q.w + self.x * q.y - self.y * q.x,
			w: self.w * q.w - self.x * q.x - self.y * q.y - self.z * q.z)
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
		return EKRotation(x: -x, y: -y, z: -z, w: w)
	}

	func conjugate(vector: EKVector4) -> EKRotation {
		return self.conjugate(quaternion: vector.toRotation())
	}

	func conjugate(quaternion: EKRotation) -> EKRotation {
		return self * quaternion * self.opposite()
	}

	public func rotate(_ vector: Any) -> EKVector3 {
		let v = EKVector3(fromObject: vector)
		let q = self
		let p = EKVector4(
			x: q.w * v.x + q.y * v.z - q.z * v.y,
			y: q.w * v.y - q.x * v.z + q.z * v.x,
			z: q.w * v.z + q.x * v.y - q.y * v.x,
			w: -q.x * v.x - q.y * v.y - q.z * v.z)
		let o = q.opposite() // FIXME: should this be quaternion opposite?
		let result = EKVector3(
			x: p.w * o.x + p.x * o.w + p.y * o.z - p.z * o.y,
			y: p.w * o.y - p.x * o.z + p.y * o.w + p.z * o.x,
			z: p.w * o.z + p.x * o.y - p.y * o.x + p.z * o.w)
		return result
	}

	public func rotate(matrix: EKMatrix) -> EKMatrix {
		return self.toMatrix() * matrix
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
