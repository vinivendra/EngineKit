// swiftlint:disable variable_name

#if os(Linux)
	import Glibc
#else
	import Darwin
#endif

public struct EKVector3: EKLanguageCompatible,
CustomStringConvertible, CustomDebugStringConvertible {
	public let x: Double
	public let y: Double
	public let z: Double

	public var debugDescription: String {
		return "<EKVector3> " + self.description
	}

	public var description: String {
		return "x: \(x), y: \(y), z: \(z)"
	}
}

//
extension EKVector3 {
	public func plus(_ vector: EKVector3) -> EKVector3 {
		return EKVector3(x: self.x + vector.x,
		                 y: self.y + vector.y,
		                 z: self.z + vector.z)
	}

	public func minus(_ vector: EKVector3) -> EKVector3 {
		return EKVector3(x: self.x - vector.x,
		                 y: self.y - vector.y,
		                 z: self.z - vector.z)
	}

	public func times(_ scalar: Double) -> EKVector3 {
		return EKVector3(x: self.x * scalar,
		                 y: self.y * scalar,
		                 z: self.z * scalar)
	}

	public func over(_ scalar: Double) -> EKVector3 {
		return self.times(1/scalar)
	}

	public func opposite() -> EKVector3 {
		return EKVector3(x: -self.x,
		                 y: -self.y,
		                 z: -self.z)
	}

	public func dot(_ vector: EKVector3) -> Double {
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

	public func cross(_ other: EKVector3) -> EKVector3 {
		return EKVector3(x: self.y * other.z - other.y * self.z,
		                 y: self.z * other.x - other.z * self.x,
		                 z: self.x * other.y - other.x * self.y)
	}

	public func translate(_ vector: EKVector3) -> EKVector3 {
		return self.plus(vector)
	}

	public func scale(_ vector: EKVector3) -> EKVector3 {
		return EKVector3(x: self.x * vector.x,
		                 y: self.y * vector.y,
		                 z: self.z * vector.z)
	}
}

extension EKVector3 {
	init() {
		self.init(0)
	}

	init(_ vector: EKVector3) {
		self.init(x: vector.x,
		          y: vector.y,
		          z: vector.z)
	}

	init(_ xyz: Double) {
		self.init(x: xyz,
		          y: xyz,
		          z: xyz)
	}

	init(_ array: [Double]) {
		self.init(x: array[zero: 0],
		          y: array[zero: 1],
		          z: array[zero: 2])
	}

	init(_ dictionary: [String: Double]) {
		self.init(x: dictionary[zero: ["0", "x", "X"]],
		          y: dictionary[zero: ["1", "y", "Y"]],
		          z: dictionary[zero: ["2", "z", "Z"]])
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
		if let vector = value as? EKVector3 {
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

extension EKVector3 {
	public func notZero() -> Bool {
		return !(x == 0 && y == 0 && z == 0)
	}

	public func translate(matrix: EKMatrix) -> EKMatrix {
		return translationToMatrix().times(matrix)
	}

	public func scale(matrix: EKMatrix) -> EKMatrix {
		return scaleToMatrix().times(matrix)
	}

	public func translationToMatrix() -> EKMatrix {
		return EKMatrix(translation: self)
	}

	public func scaleToMatrix() -> EKMatrix {
		return EKMatrix(scale: self)
	}

	public func toHomogeneousPoint() -> EKVector4 {
		return EKVector4(x: x, y: y, z: z, w: 1)
	}

	public func toHomogeneousVector() -> EKVector4 {
		return EKVector4(x: x, y: y, z: z, w: 0)
	}

	public func toArray() -> [Double] {
		return [x, y, z]
	}
}

public func == (lhs: EKVector3, rhs: EKVector3) -> Bool {
	return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}

public func != (lhs: EKVector3, rhs: EKVector3) -> Bool {
	return !(lhs == rhs)
}
