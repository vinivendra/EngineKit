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
	public static func origin() -> EKVector3 {
		return EKVector3(withXYAndZ: 0)
	}

	init(copying vector: EKVector3) {
		self.init(x: vector.x,
		          y: vector.y,
		          z: vector.z)
	}

	init(withXYAndZ xyz: Double) {
		self.init(x: xyz,
		          y: xyz,
		          z: xyz)
	}

	init(fromArray array: [Double]) {
		self.init(x: array[zero: 0],
		          y: array[zero: 1],
		          z: array[zero: 2])
	}

	init(fromDictionary dictionary: [String: Double]) {
		self.init(x: dictionary[zero: ["0", "x", "X"]],
		          y: dictionary[zero: ["1", "y", "Y"]],
		          z: dictionary[zero: ["2", "z", "Z"]])
	}

	init(fromString string: String) {
		var strings = [string]

		let separators: [UnicodeScalar] = [",", " ", "[", "]", "{", "}"]
		for separator in separators {
			strings = strings.flatMap({
				$0.split(character: separator)
			})
		}

		let doubles = strings.flatMap(Double.init)

		self.init(fromArray: doubles)
	}

	init(fromObject object: Any) {
		if let vector = object as? EKVector3 {
			self.init(copying: vector)
		} else if let array = object as? [Double] {
			self.init(fromArray: array)
		} else if let string = object as? String {
			self.init(fromString: string)
		} else if let dictionary = object as? [String: Double] {
			self.init(fromDictionary: dictionary)
		} else if let number = object as? Double {
			self.init(withXYAndZ: number)
		} else {
			self.init(withXYAndZ: 0)
		}
	}
}

extension EKVector3 {
	public func notZero() -> Bool {
		return !(x == 0 && y == 0 && z == 0)
	}

	public func translate(matrix: EKMatrix) -> EKMatrix {
		return translationToMatrix() * matrix
	}

	public func scale(matrix: EKMatrix) -> EKMatrix {
		return scaleToMatrix() * matrix
	}

	public func translationToMatrix() -> EKMatrix {
		return EKMatrix.createTranslation(self)
	}

	public func scaleToMatrix() -> EKMatrix {
		return EKMatrix.createScale(self)
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
