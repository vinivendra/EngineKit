// swiftlint:disable variable_name

#if os(Linux)
	import Glibc
#else
	import Darwin
#endif

public struct EKVector4: EKLanguageCompatible,
CustomStringConvertible, CustomDebugStringConvertible {
	public let x: Double
	public let y: Double
	public let z: Double
	public let w: Double

	public var debugDescription: String {
		return "<EKVector4> " + self.description
	}

	public var description: String {
		return "x: \(x), y: \(y), z: \(z), w: \(w)"
	}
}

extension EKVector4 {
	public func plus(_ vector: EKVector4) -> EKVector4 {
		return EKVector4(x: self.x + vector.x,
		                 y: self.y + vector.y,
		                 z: self.z + vector.z,
		                 w: min(self.w + vector.w, 1))
	}

	public func minus(_ vector: EKVector4) -> EKVector4 {
		return EKVector4(x: self.x - vector.x,
		                 y: self.y - vector.y,
		                 z: self.z - vector.z,
		                 w: max(self.w - vector.w, 0))
	}

	public func times(_ scalar: Double) -> EKVector4 {
		return EKVector4(x: self.x * scalar,
		                 y: self.y * scalar,
		                 z: self.z * scalar,
		                 w: self.w)
	}

	public func over(_ scalar: Double) -> EKVector4 {
		return self.times(1/scalar)
	}

	public func opposite() -> EKVector4 {
		return EKVector4(x: -self.x,
		                 y: -self.y,
		                 z: -self.z,
		                 w: self.w)
	}

	public func dot(_ vector: EKVector4) -> Double {
		return self.x * vector.x + self.y * vector.y + self.z * vector.z
	}

	public func normSquared() -> Double {
		return self.dot(self)
	}

	public func norm() -> Double {
		return sqrt(self.normSquared())
	}

	public func normalized() -> EKVector4 {
		let norm = self.norm()
		if norm == 0 {
			return self
		} else {
			return self.over(self.norm())
		}
	}

	public func translate(_ vector: EKVector4) -> EKVector4 {
		return self.plus(vector)
	}

	public func scale(_ vector: EKVector4) -> EKVector4 {
		return EKVector4(x: self.x * vector.x,
		                 y: self.y * vector.y,
		                 z: self.z * vector.z,
		                 w: self.w)
	}

	public func notZero() -> Bool {
		return !(x == 0 && y == 0 && z == 0)
	}
}

extension EKVector4 {
	init() {
		self.init(x: 0, y: 0, z: 0, w: 1)
	}

	init(_ v: EKVector4) {
		self.init(x: v.x,
		          y: v.y,
		          z: v.z,
		          w: v.w)
	}

	init(_ xyz: Double) {
		self.init(x: xyz,
		          y: xyz,
		          z: xyz,
		          w: 0)
	}

	init(_ array: [Double]) {
		self.init(x: array[0],
		          y: array[1],
		          z: array[2],
		          w: array[3])
	}

	init(_ dictionary: [String: Double]) {
		self.init(
			x: dictionary[["0", "x", "X"]]!,
			y: dictionary[["1", "y", "Y"]]!,
			z: dictionary[["2", "z", "Z"]]!,
			w: dictionary[["3", "w", "W", "a", "A"]]!)
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
		if let vector = value as? EKVector4 {
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

extension EKVector4 {
	public func toEKVector3() -> EKVector3 {
		return EKVector3(x: x, y: y, z: z)
	}

	public func toRotation() -> EKRotation {
		return EKRotation(x: x, y: y, z: z, w: w)
	}

	public func toArray() -> [Double] {
		return [x, y, z, w]
	}
}

extension EKVector4 {
	public func translate(matrix: EKMatrix) -> EKMatrix {
		return translationToMatrix().times(matrix)
	}

	public func translationToMatrix() -> EKMatrix {
		return EKMatrix.createTranslation(self.toEKVector3())
	}
}

public func == (lhs: EKVector4, rhs: EKVector4) -> Bool {
	return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}

public func != (lhs: EKVector4, rhs: EKVector4) -> Bool {
	return !(lhs == rhs)
}
