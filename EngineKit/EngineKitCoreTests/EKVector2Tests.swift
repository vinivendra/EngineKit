import XCTest

#if os(iOS)
	@testable import EngineKitiOS
#endif
#if os(OSX)
	@testable import EngineKitOSX
#endif

class EKVector2AsEKVector2TypeTests: EKVector2TypeTests {
	func testAll() {
		testAll(EKVector2)
	}
}

class EKVector2TypeTests: XCTestCase {

	func testAll<VectorType: EKVector2Type>(type: VectorType.Type) {
		testCreateAndEquals(type)
		testGetters(type)
		testPlus(type)
		testMinus(type)
		testTimes(type)
		testOver(type)
		testOpposite(type)
		testDot(type)
		testNormSquared(type)
		testNorm(type)
		testNormalize(type)
		testTranslate(type)
		testScale(type)
		testNotZero(type)
		testOrigin(type)
		testCreateWithXY(type)
		testCreateWithArray(type)
		testCreateWithDictionary(type)
		testCreateWithString(type)
		testCreateWithObject(type)
	}

	func testCreateAndEquals<VectorType: EKVector2Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(x: 1, y: 2)
		let equalVector = VectorType.createVector(x: 1, y: 2)
		let differentVector = VectorType.createVector(x: 4, y: 5)

		XCTAssert(testVector == equalVector)
		XCTAssert(testVector != differentVector)
	}

	func testGetters<VectorType: EKVector2Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(x: 1, y: 2)

		XCTAssertEqual(testVector.x, 1)
		XCTAssertEqual(testVector.y, 2)
	}

	func testPlus<VectorType: EKVector2Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(x: 1, y: 2)
		let otherVector = VectorType.createVector(x: 2, y: 3)

		let resultVector = testVector.plus(otherVector)

		XCTAssertEqual(resultVector.x, 3)
		XCTAssertEqual(resultVector.y, 5)
	}

	func testMinus<VectorType: EKVector2Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(x: 1, y: 2)
		let otherVector = VectorType.createVector(x: 2, y: 3)

		let resultVector = testVector.minus(otherVector)

		XCTAssertEqual(resultVector.x, -1)
		XCTAssertEqual(resultVector.y, -1)
	}

	func testTimes<VectorType: EKVector2Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(x: 1, y: 2)

		let resultVector = testVector.times(2)

		XCTAssertEqual(resultVector.x, 2)
		XCTAssertEqual(resultVector.y, 4)
	}

	func testOver<VectorType: EKVector2Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(x: 1, y: 2)

		let resultVector = testVector.over(2)

		XCTAssertEqual(resultVector.x, 0.5)
		XCTAssertEqual(resultVector.y, 1)
	}

	func testOpposite<VectorType: EKVector2Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(x: 1, y: 2)

		let resultVector = testVector.opposite()

		XCTAssertEqual(resultVector.x, -1)
		XCTAssertEqual(resultVector.y, -2)
	}

	func testDot<VectorType: EKVector2Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(x: 1, y: 2)
		let otherVector = VectorType.createVector(x: 2, y: 3)

		let result = testVector.dot(otherVector)

		XCTAssertEqual(result, 8)
	}

	func testNormSquared<VectorType: EKVector2Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(x: 3, y: 4)

		let result = testVector.normSquared()

		XCTAssertEqual(result, 25)
	}

	func testNorm<VectorType: EKVector2Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(x: 3, y: 4)

		let result = testVector.norm()

		XCTAssertEqualWithAccuracy(result, 5, accuracy: 0.0001)
	}

	func testNormalize<VectorType: EKVector2Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(x: 3, y: 3)

		let resultVector = testVector.normalize()

		XCTAssertEqualWithAccuracy(resultVector.x, 0.707, accuracy: 0.001)
		XCTAssertEqualWithAccuracy(resultVector.y, 0.707, accuracy: 0.001)
	}

	func testTranslate<VectorType: EKVector2Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(x: 1, y: 2)
		let otherVector = VectorType.createVector(x: 2, y: 3)

		let resultVector = testVector.translate(otherVector)

		XCTAssertEqual(resultVector.x, 3)
		XCTAssertEqual(resultVector.y, 5)
	}

	func testScale<VectorType: EKVector2Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(x: 1, y: 2)
		let otherVector = VectorType.createVector(x: 2, y: 3)

		let resultVector = testVector.scale(otherVector)

		XCTAssertEqual(resultVector.x, 2)
		XCTAssertEqual(resultVector.y, 6)
	}

	func testNotZero<VectorType: EKVector2Type>(type: VectorType.Type) {
		let nonZeroVector = VectorType.createVector(x: 1, y: 2)
		let zeroVector = VectorType.createVector(x: 0, y: 0)

		XCTAssert(nonZeroVector.notZero())
		XCTAssertFalse(zeroVector.notZero())
	}

	func testOrigin<VectorType: EKVector2Type>(type: VectorType.Type) {
		let originVector = VectorType.origin()

		XCTAssertFalse(originVector.notZero())
	}

	func testCreateWithXY<VectorType: EKVector2Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(xy: 3)

		XCTAssertEqual(testVector.x, 3)
		XCTAssertEqual(testVector.y, 3)
	}

	func testCreateWithArray<VectorType: EKVector2Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(array: [1, 2])
		XCTAssertEqual(testVector.x, 1)
		XCTAssertEqual(testVector.y, 2)
	}

	func testCreateWithDictionary<VectorType: EKVector2Type>
		(type: VectorType.Type) {
		let dictionaries: [[String: Double]] =
			[["0": 1, "1": 2],
			 ["x": 1, "y": 2],
			 ["X": 1, "Y": 2]]

		for dictionary in dictionaries {
			let testVector = VectorType.createVector(dictionary: dictionary)

			XCTAssertEqual(testVector.x, 1)
			XCTAssertEqual(testVector.y, 2)
		}
	}

	func testCreateWithString<VectorType: EKVector2Type>
		(type: VectorType.Type) {
		let strings: [String] = ["[1, 2]", "1.0, 2", "{{{1}{2}}"]

		for string in strings {
			let testVector = VectorType.createVector(string: string)

			XCTAssertEqual(testVector.x, 1)
			XCTAssertEqual(testVector.y, 2)
		}
	}

	func testCreateWithObject<VectorType: EKVector2Type>
		(type: VectorType.Type) {
		let objects: [Any] = ["[1, 2]",
		                      ["0": 1.0, "1": 2.0],
		                      [1.0, 2.0],
		                      VectorType.createVector(x: 1, y: 2)]

		//
		for object in objects {
			let testVector = VectorType.createVector(object: object)

			XCTAssertEqual(testVector.x, 1)
			XCTAssertEqual(testVector.y, 2)
		}

		let testVector = VectorType.createVector(object: 3.0)

		XCTAssertEqual(testVector.x, 3)
		XCTAssertEqual(testVector.y, 3)
	}
}
