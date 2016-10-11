#if os(Linux)
	import Glibc
#else
	import Darwin
#endif

public class CString {
	public let len: Int
	public var buffer: UnsafeMutablePointer<Int8>

	public init(_ string: String) {
		(len, buffer) = string.withCString {
			let len = Int(strlen($0) + 1)
			let dst = strcpy(UnsafeMutablePointer<Int8>(allocatingCapacity: len), $0)!
			return (len, dst)
		}
	}

	public init(emptyStringWithlength length: Int) {
		len = length + 1
		buffer = UnsafeMutablePointer<Int8>(allocatingCapacity: len)
		buffer[0] = 0
		buffer[length] = 0
	}

	deinit {
		buffer.deallocateCapacity(len)
	}
}

extension String {
	func withCStringPointer<ReturnType>(
		closure: (UnsafePointer<UnsafePointer<Int8>>) -> ReturnType)
		-> ReturnType {

			let cString = CString(self)
			return withUnsafePointer(&(cString.buffer)) {
				(pointer: UnsafePointer<UnsafeMutablePointer<Int8>>)
				-> ReturnType in
				let foo = unsafeBitCast(
					pointer, to: UnsafePointer<UnsafePointer<Int8>>.self)
				return closure(foo)
			}
	}

	func withCStringPointerAndLength<ReturnType>(
		closure: (UnsafePointer<UnsafePointer<Int8>>, Int) -> ReturnType)
		-> ReturnType {

			let cString = CString(self)
			return withUnsafePointer(&(cString.buffer)) {
				(pointer: UnsafePointer<UnsafeMutablePointer<Int8>>)
				-> ReturnType in
				let foo = unsafeBitCast(
					pointer, to: UnsafePointer<UnsafePointer<Int8>>.self)
				return closure(foo, cString.len)
			}
	}
}
