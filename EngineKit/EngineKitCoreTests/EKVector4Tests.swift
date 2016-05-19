import XCTest

#if os(iOS)
	@testable import EngineKitiOS
#endif
#if os(OSX)
	@testable import EngineKitOSX
#endif

class EKVector4AsEKVector4TypeTests: EKVector4TypeTests {
	func testAll() {
		testAll(EKVector4)
	}
}

class EKVector4TypeTests: XCTestCase {

	func testAll<VectorType: EKVector4Type>(type: VectorType.Type) {
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
		testCreateWithXYZ(type)
		testCreateWithArray(type)
		testCreateWithDictionary(type)
		testCreateWithString(type)
		testCreateWithObject(type)
	}

	func testCreateAndEquals<VectorType: EKVector4Type>(type: VectorType.Type) {
		let testVector: EKVector4Type
		testVector = VectorType.createVector(x: 1, y: 2, z: 3, w: 1)

		let equalVector = VectorType.createVector(x: 1, y: 2, z: 3, w: 1)
		let otherEqualVector = VectorType.createVector(x: 1, y: 2, z: 3, w: 0)
		let differentVector = VectorType.createVector(x: 4, y: 5, z: 6, w: 1)

		XCTAssert(testVector == equalVector)
		XCTAssert(testVector == otherEqualVector)
		XCTAssert(testVector != differentVector)
	}

	func testGetters<VectorType: EKVector4Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(x: 1, y: 2, z: 3, w: 1)

		XCTAssertEqual(testVector.x, 1)
		XCTAssertEqual(testVector.y, 2)
		XCTAssertEqual(testVector.z, 3)
		XCTAssertEqual(testVector.w, 1)
	}

	func testPlus<VectorType: EKVector4Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(x: 1, y: 2, z: 3, w: 1)
		let otherVector = VectorType.createVector(x: 2, y: 3, z: 1, w: 1)

		let resultVector = testVector.plus(otherVector)

		XCTAssertEqual(resultVector.x, 3)
		XCTAssertEqual(resultVector.y, 5)
		XCTAssertEqual(resultVector.z, 4)
		XCTAssertEqual(resultVector.w, 1)
	}

	func testMinus<VectorType: EKVector4Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(x: 1, y: 2, z: 3, w: 0)
		let otherVector = VectorType.createVector(x: 2, y: 3, z: 1, w: 1)

		let resultVector = testVector.minus(otherVector)

		XCTAssertEqual(resultVector.x, -1)
		XCTAssertEqual(resultVector.y, -1)
		XCTAssertEqual(resultVector.z, 2)
		XCTAssertEqual(resultVector.w, 0)
	}

	func testTimes<VectorType: EKVector4Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(x: 1, y: 2, z: 3, w: 1)

		let resultVector = testVector.times(2)

		XCTAssertEqual(resultVector.x, 2)
		XCTAssertEqual(resultVector.y, 4)
		XCTAssertEqual(resultVector.z, 6)
		XCTAssertEqual(resultVector.w, 1)
	}

	func testOver<VectorType: EKVector4Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(x: 1, y: 2, z: 3, w: 1)

		let resultVector = testVector.over(2)

		XCTAssertEqual(resultVector.x, 0.5)
		XCTAssertEqual(resultVector.y, 1)
		XCTAssertEqual(resultVector.z, 1.5)
		XCTAssertEqual(resultVector.w, 1)
	}

	func testOpposite<VectorType: EKVector4Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(x: 1, y: 2, z: 3, w: 1)

		let resultVector = testVector.opposite()

		XCTAssertEqual(resultVector.x, -1)
		XCTAssertEqual(resultVector.y, -2)
		XCTAssertEqual(resultVector.z, -3)
		XCTAssertEqual(resultVector.w, 1)
	}

	func testDot<VectorType: EKVector4Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(x: 1, y: 2, z: 3, w: 1)
		let otherVector = VectorType.createVector(x: 2, y: 3, z: 1, w: 1)

		let result = testVector.dot(otherVector)

		XCTAssertEqual(result, 11)
	}

	func testNormSquared<VectorType: EKVector4Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(x: 1, y: 2, z: 3, w: 1)

		let result = testVector.normSquared()

		XCTAssertEqual(result, 14)
	}

	func testNorm<VectorType: EKVector4Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(x: 1, y: 2, z: 3, w: 1)

		let result = testVector.norm()

		XCTAssertEqualWithAccuracy(result, 3.7416, accuracy: 0.0001)
	}

	func testNormalize<VectorType: EKVector4Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(x: 3, y: 3, z: -3, w: 1)

		let resultVector = testVector.normalize()

		XCTAssertEqualWithAccuracy(resultVector.x, 0.577, accuracy: 0.001)
		XCTAssertEqualWithAccuracy(resultVector.y, 0.577, accuracy: 0.001)
		XCTAssertEqualWithAccuracy(resultVector.z, -0.577, accuracy: 0.001)
	}

	func testTranslate<VectorType: EKVector4Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(x: 1, y: 2, z: 3, w: 1)
		let otherVector = VectorType.createVector(x: 2, y: 3, z: 1, w: 1)

		let resultVector = testVector.translate(otherVector)

		XCTAssertEqual(resultVector.x, 3)
		XCTAssertEqual(resultVector.y, 5)
		XCTAssertEqual(resultVector.z, 4)
		XCTAssertEqual(resultVector.w, 1)
	}

	func testScale<VectorType: EKVector4Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(x: 1, y: 2, z: 3, w: 1)
		let otherVector = VectorType.createVector(x: 2, y: 3, z: 1, w: 0)

		let resultVector = testVector.scale(otherVector)

		XCTAssertEqual(resultVector.x, 2)
		XCTAssertEqual(resultVector.y, 6)
		XCTAssertEqual(resultVector.z, 3)
		XCTAssertEqual(resultVector.w, 1)
	}

	func testNotZero<VectorType: EKVector4Type>(type: VectorType.Type) {
		let nonZeroVector = VectorType.createVector(x: 1, y: 2, z: 3, w: 1)
		let zeroVector = VectorType.createVector(x: 0, y: 0, z: 0, w: 1)

		XCTAssert(nonZeroVector.notZero())
		XCTAssertFalse(zeroVector.notZero())
	}

	func testOrigin<VectorType: EKVector4Type>(type: VectorType.Type) {
		let originVector = VectorType.origin()

		XCTAssertFalse(originVector.notZero())
	}

	func testCreateWithXYZ<VectorType: EKVector4Type>(type: VectorType.Type) {
		let testVector = VectorType.createVector(xyz: 3)

		XCTAssertEqual(testVector.x, 3)
		XCTAssertEqual(testVector.y, 3)
		XCTAssertEqual(testVector.z, 3)
		XCTAssertEqual(testVector.w, 0)
	}

	func testCreateWithArray<VectorType: EKVector4Type>(type: VectorType.Type) {
		var testVector = VectorType.createVector(array: [1, 2, 3, 1])
		XCTAssertEqual(testVector.x, 1)
		XCTAssertEqual(testVector.y, 2)
		XCTAssertEqual(testVector.z, 3)
		XCTAssertEqual(testVector.w, 1)

		testVector = VectorType.createVector(array: [1, 2, 3])
		XCTAssertEqual(testVector.x, 1)
		XCTAssertEqual(testVector.y, 2)
		XCTAssertEqual(testVector.z, 3)
		XCTAssertEqual(testVector.w, 0)
	}

	func testCreateWithDictionary<VectorType: EKVector4Type>
		(type: VectorType.Type) {
		let dictionaries: [[String: Double]] =
			[["0": 1, "1": 2, "2": 3, "3": 0],
			 ["x": 1, "y": 2, "z": 3, "w": 0],
			 ["X": 1, "Y": 2, "Z": 3, "W": 0],
			 ["x": 1, "y": 2, "z": 3, "a": 0],
			 ["X": 1, "Y": 2, "Z": 3, "A": 0],
			 ["X": 1, "Y": 2, "Z": 3]]

		for dictionary in dictionaries {
			let testVector = VectorType.createVector(dictionary: dictionary)

			XCTAssertEqual(testVector.x, 1)
			XCTAssertEqual(testVector.y, 2)
			XCTAssertEqual(testVector.z, 3)
			XCTAssertEqual(testVector.w, 0)
		}
	}

	func testCreateWithString<VectorType: EKVector4Type>
		(type: VectorType.Type) {
		let strings: [String] = ["[1, 2, 3, 1]",
		                         "1.0, 2, 3, 1",
		                         "{{{1}{2}{3}{1}}"]

		for string in strings {
			let testVector = VectorType.createVector(string: string)

			XCTAssertEqual(testVector.x, 1)
			XCTAssertEqual(testVector.y, 2)
			XCTAssertEqual(testVector.z, 3)
			XCTAssertEqual(testVector.w, 1)
		}
	}

	func testCreateWithObject<VectorType: EKVector4Type>
		(type: VectorType.Type) {
		let objects: [Any] = ["[1, 2, 3, 1]",
		                      ["0": 1.0, "1": 2.0, "2": 3.0, "3": 1.0],
		                      [1.0, 2.0, 3.0, 1.0],
		                      VectorType.createVector(x: 1, y: 2, z: 3, w: 1)]

		//
		for object in objects {
			let testVector = VectorType.createVector(object: object)

			XCTAssertEqual(testVector.x, 1)
			XCTAssertEqual(testVector.y, 2)
			XCTAssertEqual(testVector.z, 3)
			XCTAssertEqual(testVector.w, 1)
		}

		let testVector = VectorType.createVector(object: 3.0)

		XCTAssertEqual(testVector.x, 3)
		XCTAssertEqual(testVector.y, 3)
		XCTAssertEqual(testVector.z, 3)
		XCTAssertEqual(testVector.w, 0)
	}
}
