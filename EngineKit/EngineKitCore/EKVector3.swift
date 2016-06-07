#if os(Linux)
	import Glibc
#else
	import Darwin
#endif

public protocol EKVector3Type: class, Scriptable, CustomDebugStringConvertible,
CustomStringConvertible {

	static func createVector(x x: Double,
	                           y: Double,
	                           z: Double) -> EKVector3

	var x: Double { get }
	var y: Double { get }
	var z: Double { get }
}

//
@warn_unused_result
public func == (lhs: EKVector3, rhs: EKVector3) -> Bool {
	return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}

@warn_unused_result
public func != (lhs: EKVector3, rhs: EKVector3) -> Bool {
	return !(lhs == rhs)
}

//
extension EKVector3 {
	public func plus(object: AnyObject) -> EKVector3 {
		let vector = EKVector3.createVector(object: object)
		return EKVector3.createVector(x: self.x + vector.x,
		                              y: self.y + vector.y,
		                              z: self.z + vector.z)
	}

	public func minus(object: AnyObject) -> EKVector3 {
		let vector = EKVector3.createVector(object: object)
		return EKVector3.createVector(x: self.x - vector.x,
		                              y: self.y - vector.y,
		                              z: self.z - vector.z)
	}

	public func times(scalar: Double) -> EKVector3 {
		return EKVector3.createVector(x: self.x * scalar,
		                              y: self.y * scalar,
		                              z: self.z * scalar)
	}

	public func over(scalar: Double) -> EKVector3 {
		return self.times(1/scalar)
	}

	public func opposite() -> EKVector3 {
		return EKVector3.createVector(x: -self.x,
		                              y: -self.y,
		                              z: -self.z)
	}

	public func dot(object: AnyObject) -> Double {
		let vector = EKVector3.createVector(object: object)
		return self.x * vector.x + self.y * vector.y + self.z * vector.z
	}

	public func normSquared() -> Double {
		return self.dot(self)
	}

	public func norm() -> Double {
		return sqrt(self.normSquared())
	}

	public func normalize() -> EKVector3 {
		let norm = self.norm()
		if norm == 0 {
			return self
		} else {
			return self.over(self.norm())
		}
	}

	public func translate(object: AnyObject) -> EKVector3 {
		return self.plus(object)
	}

	public func scale(object: AnyObject) -> EKVector3 {
		let vector = EKVector3.createVector(object: object)
		return EKVector3.createVector(x: self.x * vector.x,
		                              y: self.y * vector.y,
		                              z: self.z * vector.z)
	}
}

extension EKVector3 {
	public func notZero() -> Bool {
		return !(x == 0 && y == 0 && z == 0)
	}

	public static func origin() -> EKVector3 {
		return EKVector3.createVector(x: 0, y: 0, z: 0)
	}

	public static func createVector(xyz xyz: Double) -> EKVector3 {
		return EKVector3.createVector(x: xyz,
		                              y: xyz,
		                              z: xyz)
	}

	public static func createVector(array array: [Double]) -> EKVector3 {
		return self.createVector(x: array[zero: 0],
		                         y: array[zero: 1],
		                         z: array[zero: 2])
	}

	public static func createVector(dictionary
		dictionary: [String: Double]) -> EKVector3 {

		return self.createVector(x: dictionary[zero: ["0", "x", "X"]],
		                         y: dictionary[zero: ["1", "y", "Y"]],
		                         z: dictionary[zero: ["2", "z", "Z"]])
	}

	public static func createVector(string string: String) -> EKVector3 {
		var strings = [string]

		let separators: [UnicodeScalar] = [",", " ", "[", "]", "{", "}"]
		for separator in separators {
			strings = strings.flatMap({
				$0.split(character: separator)
			})
		}

		let doubles = strings.flatMap(Double.init)

		return createVector(array: doubles)
	}

	public static func createVector(object object: AnyObject) -> EKVector3 {
		if let vector = object as? EKVector3 {
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

extension EKVector3 {
	public func translate(matrix matrix: EKMatrix) -> EKMatrix {
		return translationToMatrix() * matrix
	}

	public func scale(matrix matrix: EKMatrix) -> EKMatrix {
		return scaleToMatrix() * matrix
	}

	public func translationToMatrix() -> EKMatrix {
		return EKMatrix(m11: 1, m12: 0, m13: 0, m14: 0,
		                m21: 0, m22: 1, m23: 0, m24: 0,
		                m31: 0, m32: 0, m33: 1, m34: 0,
		                m41: x, m42: y, m43: z, m44: 1)
	}

	public func scaleToMatrix() -> EKMatrix {
		return EKMatrix(m11: x, m12: 0, m13: 0, m14: 0,
		                m21: 0, m22: y, m23: 0, m24: 0,
		                m31: 0, m32: 0, m33: z, m34: 0,
		                m41: 0, m42: 0, m43: 0, m44: 1)
	}

	public func toHomogeneousPoint() -> EKVector4 {
		return EKVector4(x: x, y: y, z: z, w: 1)
	}

	public func toHomogeneousVector() -> EKVector4 {
		return EKVector4(x: x, y: y, z: z, w: 0)
	}
}
