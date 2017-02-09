// swiftlint:disable variable_name

#if os(Linux)
	import Glibc
#else
	import Darwin
#endif

public protocol EKVector4Type: EKLanguageCompatible,
	CustomDebugStringConvertible,
CustomStringConvertible {

	static func createVector(x: Double,
	                         y: Double,
	                         z: Double,
	                         w: Double) -> EKVector4

	var x: Double { get }
	var y: Double { get }
	var z: Double { get }
	var w: Double { get }
}

public func == (lhs: EKVector4, rhs: EKVector4) -> Bool {
	return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}

public func != (lhs: EKVector4, rhs: EKVector4) -> Bool {
	return !(lhs == rhs)
}

extension EKVector4 {
	public func plus(_ object: Any) -> EKVector4 {
		let vector = EKVector4.createVector(fromObject: object)
		return EKVector4.createVector(x: self.x + vector.x,
		                              y: self.y + vector.y,
		                              z: self.z + vector.z,
		                              w: min(self.w + vector.w, 1))
	}

	public func minus(_ object: Any) -> EKVector4 {
		let vector = EKVector4.createVector(fromObject: object)
		return EKVector4.createVector(x: self.x - vector.x,
		                              y: self.y - vector.y,
		                              z: self.z - vector.z,
		                              w: max(self.w - vector.w, 0))
	}

	public func times(_ scalar: Double) -> EKVector4 {
		return EKVector4.createVector(x: self.x * scalar,
		                              y: self.y * scalar,
		                              z: self.z * scalar,
		                              w: self.w)
	}

	public func over(_ scalar: Double) -> EKVector4 {
		return self.times(1/scalar)
	}

	public func opposite() -> EKVector4 {
		return EKVector4.createVector(x: -self.x,
		                              y: -self.y,
		                              z: -self.z,
		                              w: self.w)
	}

	public func dot(_ object: Any) -> Double {
		let vector = EKVector4.createVector(fromObject: object)
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

	public func translate(_ object: Any) -> EKVector4 {
		return self.plus(object)
	}

	public func scale(_ object: Any) -> EKVector4 {
		let vector = EKVector4.createVector(fromObject: object)
		return EKVector4.createVector(x: self.x * vector.x,
		                              y: self.y * vector.y,
		                              z: self.z * vector.z,
		                              w: self.w)
	}

	public func notZero() -> Bool {
		return !(x == 0 && y == 0 && z == 0)
	}
}

extension EKVector4 {
	public static func origin() -> EKVector4 {
		return EKVector4.createVector(x: 0, y: 0, z: 0, w: 1)
	}

	public static func createVector(withUniformNumbers xyz: Double) -> EKVector4
	{
		return EKVector4.createVector(x: xyz,
		                              y: xyz,
		                              z: xyz,
		                              w: 0)
	}

	public static func createVector(fromArray array: [Double]) -> EKVector4 {
		return self.createVector(x: array[zero: 0],
		                         y: array[zero: 1],
		                         z: array[zero: 2],
		                         w: array[zero: 3])
	}

	public static func createVector(fromDictionary dictionary: [String: Double])
		-> EKVector4 {

			return self.createVector(
				x: dictionary[zero: ["0", "x", "X"]],
				y: dictionary[zero: ["1", "y", "Y"]],
				z: dictionary[zero: ["2", "z", "Z"]],
				w: dictionary[zero: ["3", "w", "W", "a", "A"]])
	}

	public static func createVector(fromString string: String) -> EKVector4 {
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

	public static func createVector(fromObject object: Any) -> EKVector4 {
		if let vector = object as? EKVector4 {
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
		return translationToMatrix() * matrix
	}

	public func translationToMatrix() -> EKMatrix {
		return EKMatrix.createTranslation(self.toEKVector3())
	}
}
