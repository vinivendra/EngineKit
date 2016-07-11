import Foundation
import JavaScriptCore

@objc public protocol EKVector2Export: JSExport {
	var x: Double { get }
	var y: Double { get }
	func plus(_ object: AnyObject) -> EKVector2
	func minus(_ object: AnyObject) -> EKVector2
	func times(_ scalar: Double) -> EKVector2
	func over(_ scalar: Double) -> EKVector2
	func opposite() -> EKVector2
	func dot(_ object: AnyObject) -> Double
	func normSquared() -> Double
	func norm() -> Double
	func normalize() -> EKVector2
	func translate(_ object: AnyObject) -> EKVector2
	func scale(_ object: AnyObject) -> EKVector2
}

@objc public final class EKVector2: NSObject, EKVector2Type, EKVector2Export,
EKLanguageCompatible {

	public let x: Double
	public let y: Double

	init(x: Double, y: Double) {
		self.x = x
		self.y = y
	}

	public static func createVector(x: Double,
	                                y: Double) -> EKVector2 {
		return EKVector2(x: x, y: y)
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

@objc public protocol EKVector3Export: JSExport {
	var x: Double { get }
	var y: Double { get }
	var z: Double { get }
	func plus(_ object: AnyObject) -> EKVector3
	func minus(_ object: AnyObject) -> EKVector3
	func times(_ scalar: Double) -> EKVector3
	func over(_ scalar: Double) -> EKVector3
	func opposite() -> EKVector3
	func dot(_ object: AnyObject) -> Double
	func normSquared() -> Double
	func norm() -> Double
	func normalize() -> EKVector3
	func translate(_ object: AnyObject) -> EKVector3
	func scale(_ object: AnyObject) -> EKVector3
	func notZero() -> Bool
	static func origin() -> EKVector3
}

@objc public final class EKVector3: NSObject, EKVector3Type, EKVector3Export,
EKLanguageCompatible {

	public let x: Double
	public let y: Double
	public let z: Double

	init(x: Double, y: Double, z: Double) {
		self.x = x
		self.y = y
		self.z = z
	}

	public static func createVector(x: Double,
	                                y: Double,
	                                z: Double) -> EKVector3 {
		return EKVector3(x: x, y: y, z: z)
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

@objc public protocol EKVector4Export: JSExport {
	var x: Double { get }
	var y: Double { get }
	var z: Double { get }
	var w: Double { get }
	func plus(_ object: AnyObject) -> EKVector4
	func minus(_ object: AnyObject) -> EKVector4
	func times(_ scalar: Double) -> EKVector4
	func over(_ scalar: Double) -> EKVector4
	func opposite() -> EKVector4
	func dot(_ object: AnyObject) -> Double
	func normSquared() -> Double
	func norm() -> Double
	func normalize() -> EKVector4
	func translate(_ object: AnyObject) -> EKVector4
	func scale(_ object: AnyObject) -> EKVector4
	func notZero() -> Bool
	static func origin() -> EKVector4
	func rotationToQuaternion() -> EKVector4
	func quaternionToMatrix() -> EKMatrix
	func rotationToMatrix() -> EKMatrix
	func rotate(matrix: EKMatrix) -> EKMatrix
	func rotate(_ vector: AnyObject) -> EKVector3
}

@objc public final class EKVector4: NSObject, EKVector4Type, EKVector4Export,
EKLanguageCompatible {

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

	public static func createVector(x: Double,
	                                y: Double,
	                                z: Double,
	                                w: Double) -> EKVector4 {
		return EKVector4(x: x, y: y, z: z, w: w)
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

@objc public class EKMatrix: NSObject, EKMatrixType, EKLanguageCompatible {
	public static func createMatrix(
		m11: Double, m12: Double, m13: Double, m14: Double,
		m21: Double, m22: Double, m23: Double, m24: Double,
		m31: Double, m32: Double, m33: Double, m34: Double,
		m41: Double, m42: Double, m43: Double, m44: Double) -> EKMatrix {
		return EKMatrix(m11: m11, m12: m12, m13: m13, m14: m14,
		                m21: m21, m22: m22, m23: m23, m24: m24,
		                m31: m31, m32: m32, m33: m33, m34: m34,
		                m41: m41, m42: m42, m43: m43, m44: m44)
	}

	init(m11: Double, m12: Double, m13: Double, m14: Double,
	     m21: Double, m22: Double, m23: Double, m24: Double,
	     m31: Double, m32: Double, m33: Double, m34: Double,
	     m41: Double, m42: Double, m43: Double, m44: Double) {
		self.m11 = m11
		self.m12 = m12
		self.m13 = m13
		self.m14 = m14
		self.m21 = m21
		self.m22 = m22
		self.m23 = m23
		self.m24 = m24
		self.m31 = m31
		self.m32 = m32
		self.m33 = m33
		self.m34 = m34
		self.m41 = m41
		self.m42 = m42
		self.m43 = m43
		self.m44 = m44
	}

	public let m11: Double
	public let m12: Double
	public let m13: Double
	public let m14: Double
	public let m21: Double
	public let m22: Double
	public let m23: Double
	public let m24: Double
	public let m31: Double
	public let m32: Double
	public let m33: Double
	public let m34: Double
	public let m41: Double
	public let m42: Double
	public let m43: Double
	public let m44: Double

	override public var debugDescription: String {
		return "((\(m11) \(m12) \(m13) \(m14)) (\(m21) \(m22) \(m23) \(m24))" +
			"(\(m31) \(m32) \(m33) \(m34)) (\(m41) \(m42) \(m43) \(m44)))"
	}

	override public var description: String {
		return debugDescription
	}
}
