import Darwin

class CString {
	private let _len: Int
	var buffer: UnsafeMutablePointer<Int8>

	init(_ string: String) {
		(_len, buffer) = string.withCString {
			let len = Int(strlen($0) + 1)
			let dst = strcpy(UnsafeMutablePointer<Int8>.alloc(len), $0)
			return (len, dst)
		}
	}

	init(emptyStringWithlength length: Int) {
		_len = length + 1
		buffer = UnsafeMutablePointer<Int8>.alloc(_len)
		buffer[0] = 0
		buffer[length] = 0
	}

	deinit {
		buffer.dealloc(_len)
	}
}

extension String {
	func withCStringPointer<ReturnType>(
		@noescape closure: (UnsafePointer<UnsafePointer<Int8>>) -> ReturnType)
		-> ReturnType {

			let cString = CString(self)
			return withUnsafePointer(&(cString.buffer)) {
				(pointer: UnsafePointer<UnsafeMutablePointer<Int8>>)
				-> ReturnType in
				let foo = unsafeBitCast(pointer,
				                        UnsafePointer<UnsafePointer<Int8>>.self)
				return closure(foo)
			}
	}
}
