import Foundation

public final class EKNSVector2: NSObject, EKVector2Type, Scriptable {
	public let x: Double
	public let y: Double

	init(x: Double, y: Double) {
		self.x = x
		self.y = y
	}

	public static func createVector(x x: Double,
	                                  y: Double) -> EKNSVector2 {
		return EKNSVector2(x: x, y: y)
	}

	public override var debugDescription: String {
		get {
			return "x: \(x), y: \(y)"
		}
	}

	public override var description: String {
		get {
			return debugDescription
		}
	}
}

public final class EKNSVector3: NSObject, EKVector3Type, Scriptable {
	public let x: Double
	public let y: Double
	public let z: Double

	init(x: Double, y: Double, z: Double) {
		self.x = x
		self.y = y
		self.z = z
	}

	public static func createVector(x x: Double,
	                                  y: Double,
	                                  z: Double) -> EKNSVector3 {
		return EKNSVector3(x: x, y: y, z: z)
	}

	public override var debugDescription: String {
		get {
			return "x: \(x), y: \(y), z: \(z)"
		}
	}

	public override var description: String {
		get {
			return debugDescription
		}
	}
}

public final class EKNSVector4: NSObject, EKVector4Type, Scriptable {
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
	                                  w: Double) -> EKNSVector4 {
		return EKNSVector4(x: x, y: y, z: z, w: w)
	}

	public override var debugDescription: String {
		get {
			return "x: \(x), y: \(y), z: \(z), w: \(w)"
		}
	}

	public override var description: String {
		get {
			return debugDescription
		}
	}
}
