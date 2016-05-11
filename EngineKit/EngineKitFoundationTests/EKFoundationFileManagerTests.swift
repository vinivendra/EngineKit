import XCTest
@testable import EngineKitOSX

class EKFoundationFileManagerTests: XCTestCase {

	let testFilename = "test.txt"
	let fileManager: EKFoundationFileManager = EKFoundationFileManager()

	override func setUp() {
		super.setUp()
	}

	override func tearDown() {
		super.tearDown()
	}

	func testPathForFilename() {
		let path = fileManager.pathForFilename(testFilename)

		XCTAssertNotNil(path)
		if let path = path {
			XCTAssert(path.hasSuffix(testFilename))
		}
	}

}
