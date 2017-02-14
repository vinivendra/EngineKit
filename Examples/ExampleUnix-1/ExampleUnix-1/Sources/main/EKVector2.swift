// swiftlint:disable variable_name

#if os(Linux)
	import Glibc
#else
	import Darwin
#endif

public struct EKVector2: EKLanguageCompatible,
CustomStringConvertible, CustomDebugStringConvertible {

	public let x: Double
	public let y: Double

	public var debugDescription: String {
		return "<EKVector2> " + self.description
	}

	public var description: String {
		return "x: \(x), y: \(y)"
	}
}

//
extension EKVector2 {
	public func plus(_ vector: EKVector2) -> EKVector2 {
		return EKVector2(x: self.x + vector.x,
		                 y: self.y + vector.y)
	}

	public func minus(_ vector: EKVector2) -> EKVector2 {
		return EKVector2(x: self.x - vector.x,
		                 y: self.y - vector.y)
	}

	public func times(_ scalar: Double) -> EKVector2 {
		return EKVector2(x: self.x * scalar,
		                 y: self.y * scalar)
	}

	public func over(_ scalar: Double) -> EKVector2 {
		return self.times(1/scalar)
	}

	public func opposite() -> EKVector2 {
		return EKVector2(x: -self.x,
		                 y: -self.y)
	}

	public func dot(_ vector: EKVector2) -> Double {
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

	public func translate(_ vector: EKVector2) -> EKVector2 {
		return self.plus(vector)
	}

	public func scale(_ vector: EKVector2) -> EKVector2 {
		return EKVector2(x: self.x * vector.x,
		                 y: self.y * vector.y)
	}
}

//
extension EKVector2 {
	public static func origin() -> EKVector2 {
		return EKVector2(x: 0, y: 0)
	}

	init(_ vector: EKVector2) {
		self.init(x: vector.x,
		          y: vector.y)
	}

	init(_ xy: Double) {
		self.init(x: xy,
		          y: xy)
	}

	init(_ array: [Double]) {
		self.init(x: array[0],
		          y: array[1])
	}

	init(_ dictionary: [String: Double]) {
		self.init(x: dictionary[["0", "x", "X"]]!,
		          y: dictionary[["1", "y", "Y"]]!)
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
		if let vector = value as? EKVector2 {
			self.init(vector)
		} else if let array = value as? [Double] {
			self.init(array)
		} else if let string = value as? String {
			self.init(string)
		} else if let dictionary = value as? [String: Double] {
			self.init(dictionary)
		} else if let number = value as? Double {
			self.init(number)
		} else {
			return nil
		}
	}
}

extension EKVector2 {
	public func notZero() -> Bool {
		return !(x == 0 && y == 0)
	}
}

public func == (lhs: EKVector2, rhs: EKVector2) -> Bool {
	return lhs.x == rhs.x && lhs.y == rhs.y
}

public func != (lhs: EKVector2, rhs: EKVector2) -> Bool {
	return !(lhs == rhs)
}
