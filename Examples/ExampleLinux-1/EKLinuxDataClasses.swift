public protocol Scriptable {}

public final class EKVector2: EKVector2Type,
	Scriptable {

	public let x: Double
	public let y: Double

	init(x: Double, y: Double) {
		self.x = x
		self.y = y
	}

	public static func createVector(x x: Double,
	                                  y: Double) -> EKVector2 {
		return EKVector2(x: x, y: y)
	}

	public var debugDescription: String {
		get {
			return "x: \(x), y: \(y)"
		}
	}

	public var description: String {
		get {
			return debugDescription
		}
	}
}
