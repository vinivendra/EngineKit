import Foundation

public protocol Scriptable {
	func toNSObject() throws -> NSObject
}

//
extension Scriptable {
	public func toReflectedNSObject() throws -> NSObject {
		var mirror: Mirror? = Mirror(reflecting: self)

		var object = [String: AnyObject]()

		while let currentMirror = mirror {
			defer {
				mirror = currentMirror.superclassMirror()
			}

			for child in currentMirror.children {
				if let label = child.label {
					if let value = child.value as? Scriptable {
						do {
							try object[label] = value.toNSObject()
						} catch let error {
							throw error
						}
					} else {
						let message = "Error converting \(self) " +
							"(\(self.dynamicType)): Unable to convert child " +
							"\(child) into an NSObject"
						throw EKError.ScriptConversionError(message: message)
					}
				}
			}
		}

		return object
	}
}

extension Scriptable where Self: NSObject {
	public func toNSObject() throws -> NSObject {
		return self
	}
}

//
extension String: Scriptable {
	public func toNSObject() throws -> NSObject {
		return NSString(string: self)
	}
}

extension Double: Scriptable {
	public func toNSObject() throws -> NSObject {
		return NSNumber(double: self)
	}
}

extension Float: Scriptable {
	public func toNSObject() throws -> NSObject {
		return NSNumber(float: self)
	}
}

extension Int: Scriptable {
	public func toNSObject() throws -> NSObject {
		return NSNumber(integer: self)
	}
}

//
extension EKEvent {
	public func toNSObject() throws -> NSObject {
		do {
			return try self.toReflectedNSObject()
		} catch let error {
			throw error
		}
	}
}

extension EKEventInputState {
	public func toNSObject() throws -> NSObject {
		return self.rawValue
	}
}

//
extension EKVector2Type {
	public func toNSObject() throws -> NSObject {
		return EKVector2(x: x, y: y)
	}
}

extension EKVector3Type {
	public func toNSObject() throws -> NSObject {
		return EKVector3(x: x, y: y, z: z)
	}
}

extension EKVector4Type {
	public func toNSObject() throws -> NSObject {
		return EKVector4(x: x, y: y, z: z, w: w)
	}
}

extension Scriptable {
	public func toNSObject() throws -> NSObject {
		return NSObject()
	}
}
