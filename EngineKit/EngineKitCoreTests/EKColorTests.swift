import XCTest

#if os(iOS)
	@testable import EngineKitiOS
#endif
#if os(OSX)
	@testable import EngineKitOSX
#endif

class EKVector4AsEKColorTests: EKColorTests {
	func testAll() {
		testAll(forType: EKVector4.self)
	}
}

class EKColorTests: XCTestCase {

	func testAll<ColorType: EKColorType>(forType type: ColorType.Type) {
		testCreateAndEquals(type: type)
		testComponents(type: type)
		testCreate(type: type)
		testCreateGrayscale(type: type)
		testCreateArray(type: type)
		testCreateName(type: type)
		testCreateSpecifics(type: type)
		testCreateObject(type: type)
	}

	func testCreateAndEquals<ColorType: EKColorType>(type: ColorType.Type) {
		let testColor = ColorType.createColor(red: 0.1,
		                                      green: 0.2,
		                                      blue: 0.3,
		                                      alpha: 0.4)

		let equalColor = ColorType.createColor(red: 0.1,
		                                       green: 0.2,
		                                       blue: 0.3,
		                                       alpha: 0.4)
		let differentColor = ColorType.createColor(red: 0.2,
		                                           green: 0.3,
		                                           blue: 0.4,
		                                           alpha: 0.5)
		let otherDifferentColor = ColorType.createColor(red: 0.1,
		                                                green: 0.2,
		                                                blue: 0.3,
		                                                alpha: 1.0)

		XCTAssert(testColor == equalColor,
		          errorMessageEqual(type, testColor, equalColor))
		XCTAssert(testColor != differentColor,
		          errorMessageNotEqual(type, testColor, differentColor))
		XCTAssert(testColor != otherDifferentColor,
		          errorMessageNotEqual(type, testColor, otherDifferentColor))
	}

	func testComponents<ColorType: EKColorType>(type: ColorType.Type) {
		let testColor = ColorType.createColor(red: 0.1,
		                                      green: 0.2,
		                                      blue: 0.3,
		                                      alpha: 0.4)

		let r: Double, g: Double, b: Double, a: Double
		(r, g, b, a) = testColor.components

		XCTAssertEqual(r, 0.1, errorMessageEqual(type, r, 0.1))
		XCTAssertEqual(g, 0.2, errorMessageEqual(type, g, 0.2))
		XCTAssertEqual(b, 0.3, errorMessageEqual(type, b, 0.3))
		XCTAssertEqual(a, 0.4, errorMessageEqual(type, a, 0.4))
	}

	func testCreate<ColorType: EKColorType>(type: ColorType.Type) {
		let testColor = ColorType.createColor(red: 0.1,
		                                      green: 0.2,
		                                      blue: 0.3)
		let r: Double, g: Double, b: Double, a: Double
		(r, g, b, a) = testColor.components

		XCTAssertEqual(r, 0.1, errorMessageEqual(type, r, 0.1))
		XCTAssertEqual(g, 0.2, errorMessageEqual(type, g, 0.2))
		XCTAssertEqual(b, 0.3, errorMessageEqual(type, b, 0.3))
		XCTAssertEqual(a, 1.0, errorMessageEqual(type, a, 1.0))
	}

	func testCreateGrayscale<ColorType: EKColorType>(type: ColorType.Type) {
		let testColor = ColorType.createColor(grayscale: 0.32)
		let r: Double, g: Double, b: Double, a: Double
		(r, g, b, a) = testColor.components

		XCTAssertEqual(r, 0.32, errorMessageEqual(type, r, 0.32))
		XCTAssertEqual(g, 0.32, errorMessageEqual(type, g, 0.32))
		XCTAssertEqual(b, 0.32, errorMessageEqual(type, b, 0.32))
		XCTAssertEqual(a, 1.0, errorMessageEqual(type, a, 1.0))
	}

	func testCreateArray<ColorType: EKColorType>(type: ColorType.Type) {
		let testColor = ColorType.createColor(array: [0.1, 0.2, 0.3, 0.4])

		let r: Double, g: Double, b: Double, a: Double
		(r, g, b, a) = testColor.components

		XCTAssertEqual(r, 0.1, errorMessageEqual(type, r, 0.1))
		XCTAssertEqual(g, 0.2, errorMessageEqual(type, g, 0.2))
		XCTAssertEqual(b, 0.3, errorMessageEqual(type, b, 0.3))
		XCTAssertEqual(a, 0.4, errorMessageEqual(type, a, 0.4))
	}

	func testCreateName<ColorType: EKColorType>(type: ColorType.Type) {
		let colorNames = ["black": [0, 0, 0, 1],
		                  "darkGray": [0.333, 0.333, 0.333, 1],
		                  "lightGray": [0.667, 0.667, 0.667, 1],
		                  "darkGrey": [0.333, 0.333, 0.333, 1],
		                  "lightGrey": [0.667, 0.667, 0.667, 1],
		                  "white": [1, 1, 1, 1],
		                  "gray": [0.5, 0.5, 0.5, 1],
		                  "grey": [0.5, 0.5, 0.5, 1],
		                  "red": [1, 0, 0, 1],
		                  "green": [0, 1, 0, 1],
		                  "blue": [0, 0, 1, 1],
		                  "cyan": [0, 1, 1, 1],
		                  "yellow": [1, 1, 0, 1],
		                  "magenta": [1, 0, 1, 1],
		                  "orange": [1, 0.5, 0, 1],
		                  "purple": [0.5, 0, 0.5, 1],
		                  "brown": [0.6, 0.4, 0.2, 1],
		                  "clear": [0, 0, 0, 0]]

		for (name, values) in colorNames {
			let testColor = ColorType.createColor(name: name)

			let r: Double, g: Double, b: Double, a: Double
			(r, g, b, a) = testColor.components

			XCTAssertEqual(r, values[0], errorMessageEqual(type, r, values[0]))
			XCTAssertEqual(g, values[1], errorMessageEqual(type, g, values[1]))
			XCTAssertEqual(b, values[2], errorMessageEqual(type, b, values[2]))
			XCTAssertEqual(a, values[3], errorMessageEqual(type, a, values[3]))
		}
	}

	func testCreateSpecifics<ColorType: EKColorType>(type: ColorType.Type) {
		let colors = [ColorType.blackColor(),
		              ColorType.darkGrayColor(),
		              ColorType.lightGrayColor(),
		              ColorType.whiteColor(),
		              ColorType.grayColor(),
		              ColorType.redColor(),
		              ColorType.greenColor(),
		              ColorType.blueColor(),
		              ColorType.cyanColor(),
		              ColorType.yellowColor(),
		              ColorType.magentaColor(),
		              ColorType.orangeColor(),
		              ColorType.purpleColor(),
		              ColorType.brownColor(),
		              ColorType.clearColor()]

		let values = [[0, 0, 0, 1],
		              [0.333, 0.333, 0.333, 1],
		              [0.667, 0.667, 0.667, 1],
		              [1, 1, 1, 1],
		              [0.5, 0.5, 0.5, 1],
		              [1, 0, 0, 1],
		              [0, 1, 0, 1],
		              [0, 0, 1, 1],
		              [0, 1, 1, 1],
		              [1, 1, 0, 1],
		              [1, 0, 1, 1],
		              [1, 0.5, 0, 1],
		              [0.5, 0, 0.5, 1],
		              [0.6, 0.4, 0.2, 1],
		              [0, 0, 0, 0]]

		for (values, color) in zip(values, colors) {
			let r: Double, g: Double, b: Double, a: Double
			(r, g, b, a) = color.components

			XCTAssertEqual(r, values[0], errorMessageEqual(type, r, values[0]))
			XCTAssertEqual(g, values[1], errorMessageEqual(type, g, values[1]))
			XCTAssertEqual(b, values[2], errorMessageEqual(type, b, values[2]))
			XCTAssertEqual(a, values[3], errorMessageEqual(type, a, values[3]))
		}
	}

	func testCreateObject<ColorType: EKColorType>(type: ColorType.Type) {
		var r: Double, g: Double, b: Double, a: Double
		let testColor = ColorType.createColor(red: 0.1,
		                                      green: 0.2,
		                                      blue: 0.3,
		                                      alpha: 0.4)

		var color = ColorType.createColor(object: testColor)
		(r, g, b, a) = color.components
		XCTAssertEqual(r, 0.1, errorMessageEqual(type, r, 0.1))
		XCTAssertEqual(g, 0.2, errorMessageEqual(type, g, 0.2))
		XCTAssertEqual(b, 0.3, errorMessageEqual(type, b, 0.3))
		XCTAssertEqual(a, 0.4, errorMessageEqual(type, a, 0.4))

		color = ColorType.createColor(object: [0.1, 0.2, 0.3, 0.4])
		(r, g, b, a) = color.components
		XCTAssertEqual(r, 0.1, errorMessageEqual(type, r, 0.1))
		XCTAssertEqual(g, 0.2, errorMessageEqual(type, g, 0.2))
		XCTAssertEqual(b, 0.3, errorMessageEqual(type, b, 0.3))
		XCTAssertEqual(a, 0.4, errorMessageEqual(type, a, 0.4))

		color = ColorType.createColor(object: 0.23)
		(r, g, b, a) = color.components
		XCTAssertEqual(r, 0.23, errorMessageEqual(type, r, 0.23))
		XCTAssertEqual(g, 0.23, errorMessageEqual(type, g, 0.23))
		XCTAssertEqual(b, 0.23, errorMessageEqual(type, b, 0.23))
		XCTAssertEqual(a, 1.0, errorMessageEqual(type, a, 1.0))

		color = ColorType.createColor(object: "brown")
		(r, g, b, a) = color.components
		XCTAssertEqual(r, 0.6, errorMessageEqual(type, r, 0.6))
		XCTAssertEqual(g, 0.4, errorMessageEqual(type, g, 0.4))
		XCTAssertEqual(b, 0.2, errorMessageEqual(type, b, 0.2))
		XCTAssertEqual(a, 1.0, errorMessageEqual(type, a, 1.0))
	}

}
