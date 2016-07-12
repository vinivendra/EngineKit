#if os(Linux)
	import Glibc
#else
	import Darwin
#endif

public protocol EKVector2Type: class,
	EKLanguageCompatible,
	CustomDebugStringConvertible,
	CustomStringConvertible {

	static func createVector(x: Double,
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
	public func plus(_ object: AnyObject) -> EKVector2 {
		let vector = EKVector2.createVector(fromObject: object)
		return EKVector2.createVector(x: self.x + vector.x,
		                              y: self.y + vector.y)
	}

	public func minus(_ object: AnyObject) -> EKVector2 {
		let vector = EKVector2.createVector(fromObject: object)
		return EKVector2.createVector(x: self.x - vector.x,
		                              y: self.y - vector.y)
	}

	public func times(_ scalar: Double) -> EKVector2 {
		return EKVector2.createVector(x: self.x * scalar,
		                              y: self.y * scalar)
	}

	public func over(_ scalar: Double) -> EKVector2 {
		return self.times(1/scalar)
	}

	public func opposite() -> EKVector2 {
		return EKVector2.createVector(x: -self.x,
		                              y: -self.y)
	}

	public func dot(_ object: AnyObject) -> Double {
		let vector = EKVector2.createVector(fromObject: object)
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

	public func translate(_ object: AnyObject) -> EKVector2 {
		return self.plus(object)
	}

	public func scale(_ object: AnyObject) -> EKVector2 {
		let vector = EKVector2.createVector(fromObject: object)
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

	public static func createVector(withUniformNumbers xy: Double)
		-> EKVector2 {
			return EKVector2.createVector(x: xy,
			                              y: xy)
	}

	public static func createVector(fromArray array: [Double]) -> EKVector2 {
		return self.createVector(x: array[zero: 0],
		                         y: array[zero: 1])
	}

	public static func createVector(fromDictionary dictionary: [String: Double])
		-> EKVector2 {
			return self.createVector(x: dictionary[zero: ["0", "x", "X"]],
			                         y: dictionary[zero: ["1", "y", "Y"]])
	}

	public static func createVector(fromString string: String) -> EKVector2 {
		var strings = [string]

		let separators: [UnicodeScalar] = [",", " ", "[", "]", "{", "}"]
		for separator in separators {
			strings = strings.flatMap({
				$0.split(character: separator)
			})
		}

		let doubles = strings.flatMap(Double.init)

		return createVector(fromArray: doubles)
	}

	public static func createVector(fromObject object: AnyObject) -> EKVector2 {
		if let vector = object as? EKVector2 {
			return vector
		} else if let array = object as? [Double] {
			return createVector(fromArray: array)
		} else if let string = object as? String {
			return createVector(fromString: string)
		} else if let dictionary = object as? [String: Double] {
			return createVector(fromDictionary: dictionary)
		} else if let number = object as? Double {
			return createVector(withUniformNumbers: number)
		}
		
		return origin()
	}
}
