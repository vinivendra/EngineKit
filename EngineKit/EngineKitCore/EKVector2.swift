#if os(Linux)
	import Glibc
#else
	import Darwin
#endif

public protocol EKVector2Type: class, Scriptable, CustomDebugStringConvertible,
	CustomStringConvertible {

	static func createVector(x x: Double,
	                           y: Double) -> EKVector2

	var x: Double { get }
	var y: Double { get }
}

//
@warn_unused_result
public func == (lhs: EKVector2, rhs: EKVector2) -> Bool {
	return lhs.x == rhs.x && lhs.y == rhs.y
}

@warn_unused_result
public func != (lhs: EKVector2, rhs: EKVector2) -> Bool {
	return !(lhs == rhs)
}

//
extension EKVector2 {
	public func plus(object: AnyObject) -> EKVector2 {
		let vector = EKVector2.createVector(object: object)
		return EKVector2.createVector(x: self.x + vector.x,
		                         y: self.y + vector.y)
	}

	public func minus(object: AnyObject) -> EKVector2 {
		let vector = EKVector2.createVector(object: object)
		return EKVector2.createVector(x: self.x - vector.x,
		                         y: self.y - vector.y)
	}

	public func times(scalar: Double) -> EKVector2 {
		return EKVector2.createVector(x: self.x * scalar,
		                         y: self.y * scalar)
	}

	public func over(scalar: Double) -> EKVector2 {
		return self.times(1/scalar)
	}

	public func opposite() -> EKVector2 {
		return EKVector2.createVector(x: -self.x,
		                         y: -self.y)
	}

	public func dot(object: AnyObject) -> Double {
		let vector = EKVector2.createVector(object: object)
		return self.x * vector.x + self.y * vector.y
	}

	public func normSquared() -> Double {
		return self.dot(self)
	}

	public func norm() -> Double {
		return sqrt(self.normSquared())
	}

	public func normalize() -> EKVector2 {
		let norm = self.norm()
		if norm == 0 {
			return self
		} else {
			return self.over(self.norm())
		}
	}

	public func translate(object: AnyObject) -> EKVector2 {
		return self.plus(object)
	}

	public func scale(object: AnyObject) -> EKVector2 {
		let vector = EKVector2.createVector(object: object)
		return EKVector2.createVector(x: self.x * vector.x,
		                         y: self.y * vector.y)
	}
}

//
extension EKVector2 {
	public func notZero() -> Bool {
		return !(x == 0 && y == 0)
	}

	public static func origin() -> EKVector2 {
		return EKVector2.createVector(x: 0, y: 0)
	}

	public static func createVector(xy xy: Double) -> EKVector2 {
		return EKVector2.createVector(x: xy,
		                         y: xy)
	}

	public static func createVector(array array: [Double]) -> EKVector2 {
		return self.createVector(x: array[zero: 0],
		                         y: array[zero: 1])
	}

	public static func createVector(dictionary
		dictionary: [String: Double]) -> EKVector2 {

		return self.createVector(x: dictionary[zero: ["0", "x", "X"]],
		                         y: dictionary[zero: ["1", "y", "Y"]])
	}

	// public static func createVector(string string: String) -> EKVector2 {
	// 	var strings = [string]

	// 	let separators = [",", " ", "[", "]", "{", "}"]
	// 	for separator in separators {
	// 		strings = strings.flatMap({
	// 			$0.componentsSeparatedByString(separator)
	// 		})
	// 	}

	// 	let doubles = strings.flatMap(Double.init)

	// 	return createVector(array: doubles)
	// }

	public static func createVector(object object: AnyObject) -> EKVector2 {
		if let vector = object as? EKVector2 {
			return vector
		} else if let array = object as? [Double] {
			return createVector(array: array)
		// } else if let string = object as? String {
		// 	return createVector(string: string)
		} else if let dictionary = object as? [String: Double] {
			return createVector(dictionary: dictionary)
		} else if let number = object as? Double {
			return createVector(xy: number)
		}

		return origin()
	}
}
