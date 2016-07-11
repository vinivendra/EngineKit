import XCTest

#if os(iOS)
	@testable import EngineKitiOS
#endif
#if os(OSX)
	@testable import EngineKitOSX
#endif

class EKVector3Tests: XCTestCase {

	func testCreateAndEquals() {
		let testVector: EKVector3 = EKVector3.createVector(x: 1, y: 2, z: 3)
		let equalVector = EKVector3.createVector(x: 1, y: 2, z: 3)
		let differentVector = EKVector3.createVector(x: 4, y: 5, z: 6)

		XCTAssert(testVector == equalVector)
		XCTAssert(testVector != differentVector)
	}

	func testGetters() {
		let testVector = EKVector3.createVector(x: 1, y: 2, z: 3)

		XCTAssertEqual(testVector.x, 1)
		XCTAssertEqual(testVector.y, 2)
		XCTAssertEqual(testVector.z, 3)
	}

	func testPlus() {
		let testVector = EKVector3.createVector(x: 1, y: 2, z: 3)
		let otherVector = EKVector3.createVector(x: 2, y: 3, z: 1)

		let resultVector = testVector.plus(otherVector)

		XCTAssertEqual(resultVector.x, 3)
		XCTAssertEqual(resultVector.y, 5)
		XCTAssertEqual(resultVector.z, 4)
	}

	func testMinus() {
		let testVector = EKVector3.createVector(x: 1, y: 2, z: 3)
		let otherVector = EKVector3.createVector(x: 2, y: 3, z: 1)

		let resultVector = testVector.minus(otherVector)

		XCTAssertEqual(resultVector.x, -1)
		XCTAssertEqual(resultVector.y, -1)
		XCTAssertEqual(resultVector.z, 2)
	}

	func testTimes() {
		let testVector = EKVector3.createVector(x: 1, y: 2, z: 3)

		let resultVector = testVector.times(2)

		XCTAssertEqual(resultVector.x, 2)
		XCTAssertEqual(resultVector.y, 4)
		XCTAssertEqual(resultVector.z, 6)
	}

	func testOver() {
		let testVector = EKVector3.createVector(x: 1, y: 2, z: 3)

		let resultVector = testVector.over(2)

		XCTAssertEqual(resultVector.x, 0.5)
		XCTAssertEqual(resultVector.y, 1)
		XCTAssertEqual(resultVector.z, 1.5)
	}

	func testOpposite() {
		let testVector = EKVector3.createVector(x: 1, y: 2, z: 3)

		let resultVector = testVector.opposite()

		XCTAssertEqual(resultVector.x, -1)
		XCTAssertEqual(resultVector.y, -2)
		XCTAssertEqual(resultVector.z, -3)
	}

	func testDot() {
		let testVector = EKVector3.createVector(x: 1, y: 2, z: 3)
		let otherVector = EKVector3.createVector(x: 2, y: 3, z: 1)

		let result = testVector.dot(otherVector)

		XCTAssertEqual(result, 11)
	}

	func testNormSquared() {
		let testVector = EKVector3.createVector(x: 1, y: 2, z: 3)

		let result = testVector.normSquared()

		XCTAssertEqual(result, 14)
	}

	func testNorm() {
		let testVector = EKVector3.createVector(x: 1, y: 2, z: 3)

		let result = testVector.norm()

		XCTAssertEqualWithAccuracy(result, 3.7416, accuracy: 0.0001)
	}

	func testNormalize() {
		let testVector = EKVector3.createVector(x: 3, y: 3, z: -3)

		let resultVector = testVector.normalize()

		XCTAssertEqualWithAccuracy(resultVector.x, 0.577, accuracy: 0.001)
		XCTAssertEqualWithAccuracy(resultVector.y, 0.577, accuracy: 0.001)
		XCTAssertEqualWithAccuracy(resultVector.z, -0.577, accuracy: 0.001)
	}

	func testTranslate() {
		let testVector = EKVector3.createVector(x: 1, y: 2, z: 3)
		let otherVector = EKVector3.createVector(x: 2, y: 3, z: 1)

		let resultVector = testVector.translate(otherVector)

		XCTAssertEqual(resultVector.x, 3)
		XCTAssertEqual(resultVector.y, 5)
		XCTAssertEqual(resultVector.z, 4)
	}

	func testScale() {
		let testVector = EKVector3.createVector(x: 1, y: 2, z: 3)
		let otherVector = EKVector3.createVector(x: 2, y: 3, z: 1)

		let resultVector = testVector.scale(otherVector)

		XCTAssertEqual(resultVector.x, 2)
		XCTAssertEqual(resultVector.y, 6)
		XCTAssertEqual(resultVector.z, 3)
	}

	func testNotZero() {
		let nonZeroVector = EKVector3.createVector(x: 1, y: 2, z: 3)
		let zeroVector = EKVector3.createVector(x: 0, y: 0, z: 0)

		XCTAssert(nonZeroVector.notZero())
		XCTAssertFalse(zeroVector.notZero())
	}

	func testOrigin() {
		let originVector = EKVector3.origin()

		XCTAssertFalse(originVector.notZero())
	}

	func testCreateWithXYZ() {
		let testVector = EKVector3.createVector(withUniformNumbers: 3)

		XCTAssertEqual(testVector.x, 3)
		XCTAssertEqual(testVector.y, 3)
		XCTAssertEqual(testVector.z, 3)
	}

	func testCreateWithArray() {
		let testVector = EKVector3.createVector(fromArray: [1, 2, 3])
		XCTAssertEqual(testVector.x, 1)
		XCTAssertEqual(testVector.y, 2)
		XCTAssertEqual(testVector.z, 3)
	}

	func testCreateWithDictionary() {
		let dictionaries: [[String: Double]] =
			[["0": 1, "1": 2, "2": 3],
			 ["x": 1, "y": 2, "z": 3],
			 ["X": 1, "Y": 2, "Z": 3]]

		for dictionary in dictionaries {
			let testVector = EKVector3.createVector(fromDictionary: dictionary)

			XCTAssertEqual(testVector.x, 1)
			XCTAssertEqual(testVector.y, 2)
			XCTAssertEqual(testVector.z, 3)
		}
	}

	func testCreateWithString() {
		let strings: [String] = ["[1, 2, 3]", "1.0, 2, 3", "{{{1}{2}{3}}"]

		for string in strings {
			let testVector = EKVector3.createVector(fromString: string)

			XCTAssertEqual(testVector.x, 1)
			XCTAssertEqual(testVector.y, 2)
			XCTAssertEqual(testVector.z, 3)
		}
	}

	func testCreateWithObject() {
		let objects: [AnyObject] = ["[1, 2, 3]",
		                            ["0": 1.0, "1": 2.0, "2": 3.0],
		                            [1.0, 2.0, 3.0],
		                            EKVector3.createVector(x: 1, y: 2, z: 3)]

		//
		for object in objects {
			let testVector = EKVector3.createVector(fromObject: object)

			XCTAssertEqual(testVector.x, 1)
			XCTAssertEqual(testVector.y, 2)
			XCTAssertEqual(testVector.z, 3)
		}

		let testVector = EKVector3.createVector(fromObject: 3.0)

		XCTAssertEqual(testVector.x, 3)
		XCTAssertEqual(testVector.y, 3)
		XCTAssertEqual(testVector.z, 3)
	}
}
