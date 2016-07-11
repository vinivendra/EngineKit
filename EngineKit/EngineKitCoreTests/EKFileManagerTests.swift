import XCTest

#if os(iOS)
	@testable import EngineKitiOS
#endif
#if os(OSX)
	@testable import EngineKitOSX
#endif

class EKFileManagerTests: XCTestCase {

	let testFilename = "test.txt"
	let fileManager: EKFileManager = OSFactory.createFileManager()

	override func setUp() {
		super.setUp()
		currentNSBundle = Bundle(for: EKFileManagerTests.self)
	}

	func testGetContentsFromFile() {
		let contents = fileManager.getContentsFromFile(testFilename)
		XCTAssertEqual(contents, "file contents")
	}

}
