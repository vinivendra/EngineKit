import Darwin

public final class EKVector2: EKVector2Type {
	public let x: Double
	public let y: Double

	init(x: Double, y: Double) {
		self.x = x
		self.y = y
	}

	public static func createVector(x x: Double,
	                                  y: Double) -> EKVector2 {
		return EKVector2(x: x, y: y)
	}
}

//
public protocol EKVector2Type: CustomDebugStringConvertible,
	CustomStringConvertible {

	static func createVector(x x: Double,
	                           y: Double) -> Self

	var x: Double { get }
	var y: Double { get }
}

extension EKVector2Type {
	public var debugDescription: String {
		get {
			return "x: \(x), y: \(y)"
		}
	}

	public var description: String {
		get {
			return debugDescription
		}
	}
}

@warn_unused_result
public func == (lhs: EKVector2Type, rhs: EKVector2Type) -> Bool {
	return lhs.x == rhs.x && lhs.y == rhs.y
}

@warn_unused_result
public func != (lhs: EKVector2Type, rhs: EKVector2Type) -> Bool {
	return !(lhs == rhs)
}

extension EKVector2Type {
	public func plus(object: Any) -> Self {
		let vector = Self.createVector(object: object)
		return Self.createVector(x: self.x + vector.x,
		                         y: self.y + vector.y)
	}

	public func minus(object: Any) -> Self {
		let vector = Self.createVector(object: object)
		return Self.createVector(x: self.x - vector.x,
		                         y: self.y - vector.y)
	}

	public func times(scalar: Double) -> Self {
		return Self.createVector(x: self.x * scalar,
		                         y: self.y * scalar)
	}

	public func over(scalar: Double) -> Self {
		return self.times(1/scalar)
	}

	public func opposite() -> Self {
		return Self.createVector(x: -self.x,
		                         y: -self.y)
	}

	public func dot(object: Any) -> Double {
		let vector = Self.createVector(object: object)
		return self.x * vector.x + self.y * vector.y
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
		                         y: self.y * vector.y)
	}
}

extension EKVector2Type {
	public func notZero() -> Bool {
		return !(x == 0 && y == 0)
	}

	public static func origin() -> Self {
		return Self.createVector(x: 0, y: 0)
	}

	public static func createVector(xy xy: Double) -> Self {
		return Self.createVector(x: xy,
		                         y: xy)
	}

	public static func createVector(array array: [Double]) -> Self {
		return self.createVector(x: array[zero: 0],
		                         y: array[zero: 1])
	}

	public static func createVector(dictionary
		dictionary: [String: Double]) -> Self {

		return self.createVector(x: dictionary[zero: ["0", "x", "X"]],
		                         y: dictionary[zero: ["1", "y", "Y"]])
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
			return createVector(xy: number)
		}

		return origin()
	}
}
