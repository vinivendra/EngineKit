import XCTest

#if os(iOS)
	@testable import EngineKitiOS
#endif
#if os(OSX)
	@testable import EngineKitOSX
#endif

class EKVector2Tests: XCTestCase {

	func testCreateAndEquals() {
		let testVector = EKVector2.createVector(x: 1, y: 2)
		let equalVector = EKVector2.createVector(x: 1, y: 2)
		let differentVector = EKVector2.createVector(x: 4, y: 5)

		XCTAssert(testVector == equalVector)
		XCTAssert(testVector != differentVector)
	}

	func testGetters() {
		let testVector = EKVector2.createVector(x: 1, y: 2)

		XCTAssertEqual(testVector.x, 1)
		XCTAssertEqual(testVector.y, 2)
	}

	func testPlus() {
		let testVector = EKVector2.createVector(x: 1, y: 2)
		let otherVector = EKVector2.createVector(x: 2, y: 3)

		let resultVector = testVector.plus(otherVector)

		XCTAssertEqual(resultVector.x, 3)
		XCTAssertEqual(resultVector.y, 5)
	}

	func testMinus() {
		let testVector = EKVector2.createVector(x: 1, y: 2)
		let otherVector = EKVector2.createVector(x: 2, y: 3)

		let resultVector = testVector.minus(otherVector)

		XCTAssertEqual(resultVector.x, -1)
		XCTAssertEqual(resultVector.y, -1)
	}

	func testTimes() {
		let testVector = EKVector2.createVector(x: 1, y: 2)

		let resultVector = testVector.times(2)

		XCTAssertEqual(resultVector.x, 2)
		XCTAssertEqual(resultVector.y, 4)
	}

	func testOver() {
		let testVector = EKVector2.createVector(x: 1, y: 2)

		let resultVector = testVector.over(2)

		XCTAssertEqual(resultVector.x, 0.5)
		XCTAssertEqual(resultVector.y, 1)
	}

	func testOpposite() {
		let testVector = EKVector2.createVector(x: 1, y: 2)

		let resultVector = testVector.opposite()

		XCTAssertEqual(resultVector.x, -1)
		XCTAssertEqual(resultVector.y, -2)
	}

	func testDot() {
		let testVector = EKVector2.createVector(x: 1, y: 2)
		let otherVector = EKVector2.createVector(x: 2, y: 3)

		let result = testVector.dot(otherVector)

		XCTAssertEqual(result, 8)
	}

	func testNormSquared() {
		let testVector = EKVector2.createVector(x: 3, y: 4)

		let result = testVector.normSquared()

		XCTAssertEqual(result, 25)
	}

	func testNorm() {
		let testVector = EKVector2.createVector(x: 3, y: 4)

		let result = testVector.norm()

		XCTAssertEqualWithAccuracy(result, 5, accuracy: 0.0001)
	}

	func testNormalize() {
		let testVector = EKVector2.createVector(x: 3, y: 3)

		let resultVector = testVector.normalize()

		XCTAssertEqualWithAccuracy(resultVector.x, 0.707, accuracy: 0.001)
		XCTAssertEqualWithAccuracy(resultVector.y, 0.707, accuracy: 0.001)
	}

	func testTranslate() {
		let testVector = EKVector2.createVector(x: 1, y: 2)
		let otherVector = EKVector2.createVector(x: 2, y: 3)

		let resultVector = testVector.translate(otherVector)

		XCTAssertEqual(resultVector.x, 3)
		XCTAssertEqual(resultVector.y, 5)
	}

	func testScale() {
		let testVector = EKVector2.createVector(x: 1, y: 2)
		let otherVector = EKVector2.createVector(x: 2, y: 3)

		let resultVector = testVector.scale(otherVector)

		XCTAssertEqual(resultVector.x, 2)
		XCTAssertEqual(resultVector.y, 6)
	}

	func testNotZero() {
		let nonZeroVector = EKVector2.createVector(x: 1, y: 2)
		let zeroVector = EKVector2.createVector(x: 0, y: 0)

		XCTAssert(nonZeroVector.notZero())
		XCTAssertFalse(zeroVector.notZero())
	}

	func testOrigin() {
		let originVector = EKVector2.origin()

		XCTAssertFalse(originVector.notZero())
	}

	func testCreateWithXY() {
		let testVector = EKVector2.createVector(xy: 3)

		XCTAssertEqual(testVector.x, 3)
		XCTAssertEqual(testVector.y, 3)
	}

	func testCreateWithArray() {
		let testVector = EKVector2.createVector(array: [1, 2])
		XCTAssertEqual(testVector.x, 1)
		XCTAssertEqual(testVector.y, 2)
	}

	func testCreateWithDictionary() {
		let dictionaries: [[String: Double]] =
			[["0": 1, "1": 2],
			 ["x": 1, "y": 2],
			 ["X": 1, "Y": 2]]

		for dictionary in dictionaries {
			let testVector = EKVector2.createVector(dictionary: dictionary)

			XCTAssertEqual(testVector.x, 1)
			XCTAssertEqual(testVector.y, 2)
		}
	}

	func testCreateWithString() {
		let strings: [String] = ["[1, 2]", "1.0, 2", "{{{1}{2}}"]

		for string in strings {
			let testVector = EKVector2.createVector(string: string)

			XCTAssertEqual(testVector.x, 1)
			XCTAssertEqual(testVector.y, 2)
		}
	}

	func testCreateWithObject() {
		let objects: [AnyObject] = ["[1, 2]",
		                            ["0": 1.0, "1": 2.0],
		                            [1.0, 2.0],
		                            EKVector2.createVector(x: 1, y: 2)]

		//
		for object in objects {
			let testVector = EKVector2.createVector(object: object)

			XCTAssertEqual(testVector.x, 1)
			XCTAssertEqual(testVector.y, 2)
		}

		let testVector = EKVector2.createVector(object: 3.0)

		XCTAssertEqual(testVector.x, 3)
		XCTAssertEqual(testVector.y, 3)
	}
}
