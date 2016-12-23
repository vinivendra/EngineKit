// swiftlint:disable variable_name

#if os(Linux)
	import Glibc
#else
	import Darwin
#endif

public protocol EKVector3Type: class,
EKLanguageCompatible {

	static func createVector(x: Double,
	                         y: Double,
	                         z: Double) -> EKVector3

	var x: Double { get }
	var y: Double { get }
	var z: Double { get }
}

//
public func == (lhs: EKVector3, rhs: EKVector3) -> Bool {
	return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}

public func != (lhs: EKVector3, rhs: EKVector3) -> Bool {
	return !(lhs == rhs)
}

//
extension EKVector3 {
	public func plus(_ object: AnyObject) -> EKVector3 {
		let vector = EKVector3.createVector(fromObject: object)
		return EKVector3.createVector(x: self.x + vector.x,
		                              y: self.y + vector.y,
		                              z: self.z + vector.z)
	}

	public func minus(_ object: AnyObject) -> EKVector3 {
		let vector = EKVector3.createVector(fromObject: object)
		return EKVector3.createVector(x: self.x - vector.x,
		                              y: self.y - vector.y,
		                              z: self.z - vector.z)
	}

	public func times(_ scalar: Double) -> EKVector3 {
		return EKVector3.createVector(x: self.x * scalar,
		                              y: self.y * scalar,
		                              z: self.z * scalar)
	}

	public func over(_ scalar: Double) -> EKVector3 {
		return self.times(1/scalar)
	}

	public func opposite() -> EKVector3 {
		return EKVector3.createVector(x: -self.x,
		                              y: -self.y,
		                              z: -self.z)
	}

	public func dot(_ object: AnyObject) -> Double {
		let vector = EKVector3.createVector(fromObject: object)
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

	public func translate(_ object: AnyObject) -> EKVector3 {
		return self.plus(object)
	}

	public func scale(_ object: AnyObject) -> EKVector3 {
		let vector = EKVector3.createVector(fromObject: object)
		return EKVector3.createVector(x: self.x * vector.x,
		                              y: self.y * vector.y,
		                              z: self.z * vector.z)
	}
}

extension EKVector3 {
	public func notZero() -> Bool {
		return !(x == 0 && y == 0 && z == 0)
	}

	public static func origin() -> EKVector3 {
		return EKVector3.createVector(x: 0, y: 0, z: 0)
	}

	public static func createVector(withUniformNumbers xyz: Double)
		-> EKVector3 {
			return EKVector3.createVector(x: xyz,
			                              y: xyz,
			                              z: xyz)
	}

	public static func createVector(fromArray array: [Double]) -> EKVector3 {
		return self.createVector(x: array[zero: 0],
		                         y: array[zero: 1],
		                         z: array[zero: 2])
	}

	public static func createVector(fromDictionary dictionary: [String: Double])
		-> EKVector3 {

			return self.createVector(x: dictionary[zero: ["0", "x", "X"]],
			                         y: dictionary[zero: ["1", "y", "Y"]],
			                         z: dictionary[zero: ["2", "z", "Z"]])
	}

	public static func createVector(fromString string: String) -> EKVector3 {
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

	public static func createVector(fromObject object: AnyObject) -> EKVector3 {
		if let vector = object as? EKVector3 {
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

extension EKVector3 {
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
}

extension EKVector3 {
	public func cross(_ other: EKVector3) -> EKVector3 {
		return EKVector3(x: self.y * other.z - other.y * self.z,
		                 y: self.z * other.x - other.z * self.x,
		                 z: self.x * other.y - other.x * self.y)
	}
}
