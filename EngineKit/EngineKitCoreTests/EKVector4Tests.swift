import XCTest

#if os(iOS)
	@testable import EngineKitiOS
#endif
#if os(OSX)
	@testable import EngineKitOSX
#endif

class EKVector4Tests: XCTestCase {

	func testCreateAndEquals() {
		let testVector = EKVector4.createVector(x: 1, y: 2, z: 3, w: 1)

		let equalVector = EKVector4.createVector(x: 1, y: 2, z: 3, w: 1)
		let otherEqualVector = EKVector4.createVector(x: 1, y: 2, z: 3, w: 0)
		let differentVector = EKVector4.createVector(x: 4, y: 5, z: 6, w: 1)

		XCTAssert(testVector == equalVector)
		XCTAssert(testVector == otherEqualVector)
		XCTAssert(testVector != differentVector)
	}

	func testGetters() {
		let testVector = EKVector4.createVector(x: 1, y: 2, z: 3, w: 1)

		XCTAssertEqual(testVector.x, 1)
		XCTAssertEqual(testVector.y, 2)
		XCTAssertEqual(testVector.z, 3)
		XCTAssertEqual(testVector.w, 1)
	}

	func testPlus() {
		let testVector = EKVector4.createVector(x: 1, y: 2, z: 3, w: 1)
		let otherVector = EKVector4.createVector(x: 2, y: 3, z: 1, w: 1)

		let resultVector = testVector.plus(otherVector)

		XCTAssertEqual(resultVector.x, 3)
		XCTAssertEqual(resultVector.y, 5)
		XCTAssertEqual(resultVector.z, 4)
		XCTAssertEqual(resultVector.w, 1)
	}

	func testMinus() {
		let testVector = EKVector4.createVector(x: 1, y: 2, z: 3, w: 0)
		let otherVector = EKVector4.createVector(x: 2, y: 3, z: 1, w: 1)

		let resultVector = testVector.minus(otherVector)

		XCTAssertEqual(resultVector.x, -1)
		XCTAssertEqual(resultVector.y, -1)
		XCTAssertEqual(resultVector.z, 2)
		XCTAssertEqual(resultVector.w, 0)
	}

	func testTimes() {
		let testVector = EKVector4.createVector(x: 1, y: 2, z: 3, w: 1)

		let resultVector = testVector.times(2)

		XCTAssertEqual(resultVector.x, 2)
		XCTAssertEqual(resultVector.y, 4)
		XCTAssertEqual(resultVector.z, 6)
		XCTAssertEqual(resultVector.w, 1)
	}

	func testOver() {
		let testVector = EKVector4.createVector(x: 1, y: 2, z: 3, w: 1)

		let resultVector = testVector.over(2)

		XCTAssertEqual(resultVector.x, 0.5)
		XCTAssertEqual(resultVector.y, 1)
		XCTAssertEqual(resultVector.z, 1.5)
		XCTAssertEqual(resultVector.w, 1)
	}

	func testOpposite() {
		let testVector = EKVector4.createVector(x: 1, y: 2, z: 3, w: 1)

		let resultVector = testVector.opposite()

		XCTAssertEqual(resultVector.x, -1)
		XCTAssertEqual(resultVector.y, -2)
		XCTAssertEqual(resultVector.z, -3)
		XCTAssertEqual(resultVector.w, 1)
	}

	func testDot() {
		let testVector = EKVector4.createVector(x: 1, y: 2, z: 3, w: 1)
		let otherVector = EKVector4.createVector(x: 2, y: 3, z: 1, w: 1)

		let result = testVector.dot(otherVector)

		XCTAssertEqual(result, 11)
	}

	func testNormSquared() {
		let testVector = EKVector4.createVector(x: 1, y: 2, z: 3, w: 1)

		let result = testVector.normSquared()

		XCTAssertEqual(result, 14)
	}

	func testNorm() {
		let testVector = EKVector4.createVector(x: 1, y: 2, z: 3, w: 1)

		let result = testVector.norm()

		XCTAssertEqualWithAccuracy(result, 3.7416, accuracy: 0.0001)
	}

	func testNormalize() {
		let testVector = EKVector4.createVector(x: 3, y: 3, z: -3, w: 1)

		let resultVector = testVector.normalize()

		XCTAssertEqualWithAccuracy(resultVector.x, 0.577, accuracy: 0.001)
		XCTAssertEqualWithAccuracy(resultVector.y, 0.577, accuracy: 0.001)
		XCTAssertEqualWithAccuracy(resultVector.z, -0.577, accuracy: 0.001)
	}

	func testTranslate() {
		let testVector = EKVector4.createVector(x: 1, y: 2, z: 3, w: 1)
		let otherVector = EKVector4.createVector(x: 2, y: 3, z: 1, w: 1)

		let resultVector = testVector.translate(otherVector)

		XCTAssertEqual(resultVector.x, 3)
		XCTAssertEqual(resultVector.y, 5)
		XCTAssertEqual(resultVector.z, 4)
		XCTAssertEqual(resultVector.w, 1)
	}

	func testScale() {
		let testVector = EKVector4.createVector(x: 1, y: 2, z: 3, w: 1)
		let otherVector = EKVector4.createVector(x: 2, y: 3, z: 1, w: 0)

		let resultVector = testVector.scale(otherVector)

		XCTAssertEqual(resultVector.x, 2)
		XCTAssertEqual(resultVector.y, 6)
		XCTAssertEqual(resultVector.z, 3)
		XCTAssertEqual(resultVector.w, 1)
	}

	func testNotZero() {
		let nonZeroVector = EKVector4.createVector(x: 1, y: 2, z: 3, w: 1)
		let zeroVector = EKVector4.createVector(x: 0, y: 0, z: 0, w: 1)

		XCTAssert(nonZeroVector.notZero())
		XCTAssertFalse(zeroVector.notZero())
	}

	func testOrigin() {
		let originVector = EKVector4.origin()

		XCTAssertFalse(originVector.notZero())
	}

	func testCreateWithXYZ() {
		let testVector = EKVector4.createVector(xyz: 3)

		XCTAssertEqual(testVector.x, 3)
		XCTAssertEqual(testVector.y, 3)
		XCTAssertEqual(testVector.z, 3)
		XCTAssertEqual(testVector.w, 0)
	}

	func testCreateWithArray() {
		var testVector = EKVector4.createVector(array: [1, 2, 3, 1])
		XCTAssertEqual(testVector.x, 1)
		XCTAssertEqual(testVector.y, 2)
		XCTAssertEqual(testVector.z, 3)
		XCTAssertEqual(testVector.w, 1)

		testVector = EKVector4.createVector(array: [1, 2, 3])
		XCTAssertEqual(testVector.x, 1)
		XCTAssertEqual(testVector.y, 2)
		XCTAssertEqual(testVector.z, 3)
		XCTAssertEqual(testVector.w, 0)
	}

	func testCreateWithDictionary() {
		let dictionaries: [[String: Double]] =
			[["0": 1, "1": 2, "2": 3, "3": 0],
			 ["x": 1, "y": 2, "z": 3, "w": 0],
			 ["X": 1, "Y": 2, "Z": 3, "W": 0],
			 ["x": 1, "y": 2, "z": 3, "a": 0],
			 ["X": 1, "Y": 2, "Z": 3, "A": 0],
			 ["X": 1, "Y": 2, "Z": 3]]

		for dictionary in dictionaries {
			let testVector = EKVector4.createVector(dictionary: dictionary)

			XCTAssertEqual(testVector.x, 1)
			XCTAssertEqual(testVector.y, 2)
			XCTAssertEqual(testVector.z, 3)
			XCTAssertEqual(testVector.w, 0)
		}
	}

	func testCreateWithString() {
		let strings: [String] = ["[1, 2, 3, 1]",
		                         "1.0, 2, 3, 1",
		                         "{{{1}{2}{3}{1}}"]

		for string in strings {
			let testVector = EKVector4.createVector(string: string)

			XCTAssertEqual(testVector.x, 1)
			XCTAssertEqual(testVector.y, 2)
			XCTAssertEqual(testVector.z, 3)
			XCTAssertEqual(testVector.w, 1)
		}
	}

	func testCreateWithObject() {
		let objects: [AnyObject] = ["[1, 2, 3, 1]",
		                            ["0": 1.0, "1": 2.0, "2": 3.0, "3": 1.0],
		                            [1.0, 2.0, 3.0, 1.0],
		                            EKVector4.createVector(
										x: 1, y: 2, z: 3, w: 1)]

		//
		for object in objects {
			let testVector = EKVector4.createVector(object: object)

			XCTAssertEqual(testVector.x, 1)
			XCTAssertEqual(testVector.y, 2)
			XCTAssertEqual(testVector.z, 3)
			XCTAssertEqual(testVector.w, 1)
		}

		let testVector = EKVector4.createVector(object: 3.0)

		XCTAssertEqual(testVector.x, 3)
		XCTAssertEqual(testVector.y, 3)
		XCTAssertEqual(testVector.z, 3)
		XCTAssertEqual(testVector.w, 0)
	}
}
