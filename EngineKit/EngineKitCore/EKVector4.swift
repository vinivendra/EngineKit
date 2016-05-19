import Darwin

public final class EKVector4: EKVector4Type {
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

	public static func createVector(x x: Double,
	                                  y: Double,
	                                  z: Double,
	                                  w: Double) -> EKVector4 {
		return EKVector4(x: x, y: y, z: z, w: w)
	}
}

//
public protocol EKVector4Type: CustomDebugStringConvertible,
	CustomStringConvertible {

	static func createVector(x x: Double,
	                           y: Double,
	                           z: Double,
	                           w: Double) -> Self

	var x: Double { get }
	var y: Double { get }
	var z: Double { get }
	var w: Double { get }
}

extension EKVector4Type {
	public var debugDescription: String {
		get {
			return "x: \(x), y: \(y), z: \(z), w: \(w)"
		}
	}

	public var description: String {
		get {
			return debugDescription
		}
	}
}

@warn_unused_result
public func == (lhs: EKVector4Type, rhs: EKVector4Type) -> Bool {
	return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}

@warn_unused_result
public func != (lhs: EKVector4Type, rhs: EKVector4Type) -> Bool {
	return !(lhs == rhs)
}

extension EKVector4Type {
	public func plus(object: Any) -> Self {
		let vector = Self.createVector(object: object)
		return Self.createVector(x: self.x + vector.x,
		                         y: self.y + vector.y,
		                         z: self.z + vector.z,
		                         w: min(self.w + vector.w, 1))
	}

	public func minus(object: Any) -> Self {
		let vector = Self.createVector(object: object)
		return Self.createVector(x: self.x - vector.x,
		                         y: self.y - vector.y,
		                         z: self.z - vector.z,
		                         w: max(self.w - vector.w, 0))
	}

	public func times(scalar: Double) -> Self {
		return Self.createVector(x: self.x * scalar,
		                         y: self.y * scalar,
		                         z: self.z * scalar,
		                         w: self.w)
	}

	public func over(scalar: Double) -> Self {
		return self.times(1/scalar)
	}

	public func opposite() -> Self {
		return Self.createVector(x: -self.x,
		                         y: -self.y,
		                         z: -self.z,
								 w: self.w)
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

	public func normalize() -> Self {
		return self.over(self.norm())
	}

	public func translate(object: Any) -> Self {
		return self.plus(object)
	}

	public func scale(object: Any) -> Self {
		let vector = Self.createVector(object: object)
		return Self.createVector(x: self.x * vector.x,
		                         y: self.y * vector.y,
		                         z: self.z * vector.z,
								 w: self.w)
	}
}

extension EKVector4Type {
	public func notZero() -> Bool {
		return !(x == 0 && y == 0 && z == 0)
	}

	public static func origin() -> Self {
		return Self.createVector(x: 0, y: 0, z: 0, w: 1)
	}

	public static func createVector(xyz xyz: Double) -> Self {
		return Self.createVector(x: xyz,
		                         y: xyz,
		                         z: xyz,
		                         w: 0)
	}

	public static func createVector(array array: [Double]) -> Self {
		return self.createVector(x: array[zero: 0],
		                         y: array[zero: 1],
		                         z: array[zero: 2],
		                         w: array[zero: 3])
	}

	public static func createVector(dictionary
		dictionary: [String: Double]) -> Self {

		return self.createVector(x: dictionary[zero: ["0", "x", "X"]],
		                         y: dictionary[zero: ["1", "y", "Y"]],
		                         z: dictionary[zero: ["2", "z", "Z"]],
		                         w: dictionary[zero: ["3", "w", "W", "a", "A"]])
	}

	public static func createVector(string string: String) -> Self {
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

	public static func createVector(object object: Any) -> Self {
		if let vector = object as? Self {
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
