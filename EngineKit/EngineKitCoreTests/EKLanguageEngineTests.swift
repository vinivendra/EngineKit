import XCTest

#if os(iOS)
	@testable import EngineKitiOS
#endif
#if os(OSX)
	@testable import EngineKitOSX
#endif

class EKLanguageEngineTests: XCTestCase {

	let engine = EKJSCoreEngine()

	override func setUp() {
		super.setUp()
		currentNSBundle = NSBundle(forClass: EKFoundationFileManagerTests.self)
	}

	func testRunScript() {
		// Tests only if the function doesn't crash... :/
		engine.runScript(filename: "testScript")
	}

}
