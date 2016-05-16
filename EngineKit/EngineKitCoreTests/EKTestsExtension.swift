import XCTest

extension XCTestCase {

	func errorMessage<T>
		(type: T.Type, message: String) -> String {

		return "Testing type \(T.self): " + message
	}

	func errorMessageEqual<T>
		(type: T.Type, _ object1: Any, _ object2: Any) -> String {

		let message = "(\(object1)) is not equal to (\(object2))"
		return errorMessage(T.self, message: message)
	}

	func errorMessageNotEqual<T>
		(type: T.Type, _ object1: Any, _ object2: Any) -> String {

		let message = "<\(object1)> should not be equal to <\(object2)>"
		return errorMessage(T.self, message: message)
	}

}
