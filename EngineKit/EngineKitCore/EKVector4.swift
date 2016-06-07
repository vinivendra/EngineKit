#if os(Linux)
	import Glibc
#else
	import Darwin
#endif

public protocol EKVector4Type: Scriptable, CustomDebugStringConvertible,
CustomStringConvertible {

	static func createVector(x x: Double,
	                           y: Double,
	                           z: Double,
	                           w: Double) -> EKVector4

	var x: Double { get }
	var y: Double { get }
	var z: Double { get }
	var w: Double { get }
}

@warn_unused_result
public func == (lhs: EKVector4, rhs: EKVector4) -> Bool {
	return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}

@warn_unused_result
public func != (lhs: EKVector4, rhs: EKVector4) -> Bool {
	return !(lhs == rhs)
}

extension EKVector4 {
	public func plus(object: AnyObject) -> EKVector4 {
		let vector = EKVector4.createVector(object: object)
		return EKVector4.createVector(x: self.x + vector.x,
		                              y: self.y + vector.y,
		                              z: self.z + vector.z,
		                              w: min(self.w + vector.w, 1))
	}

	public func minus(object: AnyObject) -> EKVector4 {
		let vector = EKVector4.createVector(object: object)
		return EKVector4.createVector(x: self.x - vector.x,
		                              y: self.y - vector.y,
		                              z: self.z - vector.z,
		                              w: max(self.w - vector.w, 0))
	}

	public func times(scalar: Double) -> EKVector4 {
		return EKVector4.createVector(x: self.x * scalar,
		                              y: self.y * scalar,
		                              z: self.z * scalar,
		                              w: self.w)
	}

	public func over(scalar: Double) -> EKVector4 {
		return self.times(1/scalar)
	}

	public func opposite() -> EKVector4 {
		return EKVector4.createVector(x: -self.x,
		                              y: -self.y,
		                              z: -self.z,
		                              w: self.w)
	}

	public func dot(object: AnyObject) -> Double {
		let vector = EKVector4.createVector(object: object)
		return self.x * vector.x + self.y * vector.y + self.z * vector.z
	}

	public func normSquared() -> Double {
		return self.dot(self)
	}

	public func norm() -> Double {
		return sqrt(self.normSquared())
	}

	public func normalize() -> EKVector4 {
		let norm = self.norm()
		if norm == 0 {
			return self
		} else {
			return self.over(self.norm())
		}
	}

	public func translate(object: AnyObject) -> EKVector4 {
		return self.plus(object)
	}

	public func scale(object: AnyObject) -> EKVector4 {
		let vector = EKVector4.createVector(object: object)
		return EKVector4.createVector(x: self.x * vector.x,
		                              y: self.y * vector.y,
		                              z: self.z * vector.z,
		                              w: self.w)
	}
}

extension EKVector4 {
	public func notZero() -> Bool {
		return !(x == 0 && y == 0 && z == 0)
	}

	public static func origin() -> EKVector4 {
		return EKVector4.createVector(x: 0, y: 0, z: 0, w: 1)
	}

	public static func createVector(xyz xyz: Double) -> EKVector4 {
		return EKVector4.createVector(x: xyz,
		                              y: xyz,
		                              z: xyz,
		                              w: 0)
	}

	public static func createVector(array array: [Double]) -> EKVector4 {
		return self.createVector(x: array[zero: 0],
		                         y: array[zero: 1],
		                         z: array[zero: 2],
		                         w: array[zero: 3])
	}

	public static func createVector(dictionary
		dictionary: [String: Double]) -> EKVector4 {

		return self.createVector(x: dictionary[zero: ["0", "x", "X"]],
		                         y: dictionary[zero: ["1", "y", "Y"]],
		                         z: dictionary[zero: ["2", "z", "Z"]],
		                         w: dictionary[zero: ["3", "w", "W", "a", "A"]])
	}

	public static func createVector(string string: String) -> EKVector4 {
		var strings = [string]

		let separators = [",", " ", "[", "]", "{", "}"]
		for separator in separators {
			strings = strings.flatMap({
				$0.split(character: separator)
			})
		}

		let doubles = strings.flatMap(Double.init)

		return createVector(array: doubles)
	}

	public static func createVector(object object: AnyObject) -> EKVector4 {
		if let vector = object as? EKVector4 {
			return vector
		} else if let array = object as? [Double] {
			return createVector(array: array)
		} else if let string = object as? String {
			return createVector(string: string)
		} else if let dictionary = object as? [String: Double] {
			return createVector(dictionary: dictionary)
		} else if let number = object as? Double {
			return createVector(xyz: number)
		}

		return origin()
	}
}

extension EKVector4 {
	public func rotationToQuaternion() -> EKVector4 {
		let halfAngle = w / 2
		let cosine = cos(halfAngle)
		let sine = sin(halfAngle)
		return EKVector4(x: sine * x,
		                 y: sine * y,
		                 z: sine * z,
		                 w: cosine)
	}

	public func quaternionToMatrix() -> EKMatrix {
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

	public func rotationToMatrix() -> EKMatrix {
		return rotationToQuaternion().quaternionToMatrix()
	}

	public func rotate(matrix matrix: EKMatrix) -> EKMatrix {
		return rotationToMatrix() * matrix
	}

	public func rotate(vector: AnyObject) -> EKVector3 {
		let v = EKVector3.createVector(object: vector)
		let q = self.rotationToQuaternion()
		let p = EKVector4(x: q.w * v.x + q.y * v.z - q.z * v.y,
		                  y: q.w * v.y - q.x * v.z + q.z * v.x,
		                  z: q.w * v.z + q.x * v.y - q.y * v.x,
		                  w: -q.x * v.x - q.y * v.y - q.z * v.z)
		let o = q.opposite()
		let result = EKVector3(
			x: p.w * o.x + p.x * o.w + p.y * o.z - p.z * o.y,
			y: p.w * o.y - p.x * o.z + p.y * o.w + p.z * o.x,
			z: p.w * o.z + p.x * o.y - p.y * o.x + p.z * o.w)
		return result
	}

	public func translate(matrix matrix: EKMatrix) -> EKMatrix {
		return translationToMatrix() * matrix
	}

	public func translationToMatrix() -> EKMatrix {
		return EKMatrix(m11: 1, m12: 0, m13: 0, m14: 0,
		                m21: 0, m22: 1, m23: 0, m24: 0,
		                m31: 0, m32: 0, m33: 1, m34: 0,
		                m41: x, m42: y, m43: z, m44: 1)
	}

	func multiplyAsQuaternion(vector vector: EKVector3) -> EKVector4 {
		return multiplyAsQuaternion(quaternion: vector.toHomogeneousVector())
	}

	func multiplyAsQuaternion(quaternion q: EKVector4) -> EKVector4 {
		return EKVector4(x: self.w * q.x + self.x * q.w + self.y * q.z -
			self.z * q.y,
		                 y: self.w * q.y + self.y * q.w - self.x * q.z +
							self.z * q.x,
		                 z: self.w * q.z + self.z * q.w + self.x * q.y -
							self.y * q.x,
		                 w: self.w * q.w - self.x * q.x - self.y * q.y -
							self.z * q.z)
	}

	func conjugate(quaternion q: EKVector4) -> EKVector4 {
		let opposite = self.oppositeQuaternion()
		let step = self.multiplyAsQuaternion(quaternion: q)
		return step.multiplyAsQuaternion(quaternion: opposite)
	}

	func conjugate(vector v: EKVector3) -> EKVector4 {
		let opposite = self.oppositeQuaternion()
		let step = self.multiplyAsQuaternion(quaternion: v.toHomogeneousVector())
		return step.multiplyAsQuaternion(quaternion: opposite)
	}

	func oppositeQuaternion() -> EKVector4 {
		return EKVector4(x: -self.x, y: -self.y, z: -self.z, w: self.w)
	}

	public func unitQuaternion() -> EKVector4 {
		let normSquared = x*x + y*y + z*z + w*w
		let norm = sqrt(normSquared)
		return EKVector4(x: x / norm, y: y / norm, z: z / norm, w: w / norm)
	}
}
