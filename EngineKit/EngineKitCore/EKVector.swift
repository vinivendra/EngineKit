import Darwin

public class EKVector: EKVectorType {
	public let x: Double
	public let y: Double
	public let z: Double

	init(x: Double, y: Double, z: Double) {
		self.x = x
		self.y = y
		self.z = z
	}

	public static func createVector(x x: Double,
	                                  y: Double,
	                                  z: Double) -> EKVectorType {
		return EKVector(x: x, y: y, z: z)
	}
}

//
public protocol EKVectorType: class, CustomDebugStringConvertible {
	static func createVector(x x: Double,
	                           y: Double,
	                           z: Double) -> EKVectorType

	var x: Double { get }
	var y: Double { get }
	var z: Double { get }
}

extension EKVectorType {
	public var debugDescription: String {
		get {
			return "x: \(x), y: \(y), z: \(z)"
		}
	}
}

@warn_unused_result
public func == (lhs: EKVectorType, rhs: EKVectorType) -> Bool {
	return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}

@warn_unused_result
public func != (lhs: EKVectorType, rhs: EKVectorType) -> Bool {
	return !(lhs == rhs)
}

extension EKVectorType {
	public func plus(object: Any) -> EKVectorType {
		let vector = Self.createVector(object: object)
		return Self.createVector(x: self.x + vector.x,
		                         y: self.y + vector.y,
		                         z: self.z + vector.z)
	}

	public func minus(object: Any) -> EKVectorType {
		let vector = Self.createVector(object: object)
		return Self.createVector(x: self.x - vector.x,
		                         y: self.y - vector.y,
		                         z: self.z - vector.z)
	}

	public func times(scalar: Double) -> EKVectorType {
		return Self.createVector(x: self.x * scalar,
		                         y: self.y * scalar,
		                         z: self.z * scalar)
	}

	public func over(scalar: Double) -> EKVectorType {
		return self.times(1/scalar)
	}

	public func opposite() -> EKVectorType {
		return Self.createVector(x: -self.x,
		                         y: -self.y,
		                         z: -self.z)
	}

	public func dot(object: Any) -> Double {
		let vector = Self.createVector(object: object)
		return self.x * vector.x + self.y * vector.y + self.z * vector.z
	}

	public func normSquared() -> Double {
		return self.dot(self)
	}

	public func norm() -> Double {
		return sqrt(self.normSquared())
	}

	public func normalize() -> EKVectorType {
		return self.over(self.norm())
	}

	public func translate(object: Any) -> EKVectorType {
		return self.plus(object)
	}

	public func scale(object: Any) -> EKVectorType {
		let vector = Self.createVector(object: object)
		return Self.createVector(x: self.x * vector.x,
		                         y: self.y * vector.y,
		                         z: self.z * vector.z)
	}
}

extension EKVectorType {
	public func notZero() -> Bool {
		return !(x == 0 && y == 0 && z == 0)
	}

	public static func origin() -> EKVectorType {
		return Self.createVector(x: 0, y: 0, z: 0)
	}

	public static func createVector(xyz xyz: Double) -> EKVectorType {
		return Self.createVector(x: xyz,
		                         y: xyz,
		                         z: xyz)
	}

	public static func createVector(array array: [Double]) -> EKVectorType {
		return self.createVector(x: array[zero: 0],
		                         y: array[zero: 1],
		                         z: array[zero: 2])
	}

	public static func createVector(dictionary
		dictionary: [String: Double]) -> EKVectorType {

		return self.createVector(x: dictionary[zero: ["0", "x", "X"]],
		                         y: dictionary[zero: ["1", "y", "Y"]],
		                         z: dictionary[zero: ["2", "z", "Z"]])
	}

	public static func createVector(string string: String) -> EKVectorType {
		var strings = [string]

		let separators = [",", " ", "[", "]", "{", "}"]
		for separator in separators {
			strings = strings.flatMap({
				$0.componentsSeparatedByString(separator)
			})
		}

		let doubles = strings.flatMap(Double.init)

		return createVector(array: doubles)
	}

	public static func createVector(object object: Any) -> EKVectorType {
		if let vector = object as? EKVectorType {
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
