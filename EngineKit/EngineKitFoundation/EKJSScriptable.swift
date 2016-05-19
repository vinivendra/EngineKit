import Foundation

public protocol Initable {
	init()
}

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
					if let value = child.value as? NSObject {
						object[label] = value
					} else if let value = child.value as? Scriptable {
						do {
							try object[label] = value.toNSObject()
						} catch let error {
							throw error
						}
					} else {
						let message = "Error converting \(self.dynamicType) " +
							"\(self): Unable to convert child \(child) into " +
							"and NSObject."
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

extension EKEvent {
	public func toNSObject() throws -> NSObject {
		do {
			return try self.toReflectedNSObject()
		} catch let error {
			throw error
		}
	}
}
