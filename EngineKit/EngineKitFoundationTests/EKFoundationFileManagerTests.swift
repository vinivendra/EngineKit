import XCTest

#if os(iOS)
	@testable import EngineKitiOS
#endif
#if os(OSX)
	@testable import EngineKitOSX
#endif

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

		let failPath = fileManager.pathForFilename("fail.txt")
		XCTAssertNil(failPath)
	}

	func testGetContentsFromFile() {
		let contents = fileManager.getContentsFromFile(testFilename)
		XCTAssertEqual(contents, "file contents")
	}

}
