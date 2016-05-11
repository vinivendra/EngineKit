import XCTest
import JavaScriptCore

#if os(iOS)
	@testable import EngineKitiOS
#endif
#if os(OSX)
	@testable import EngineKitOSX
#endif

@objc protocol JSTestExport: JSExport {
	func test()
}
@objc class JSTest: NSObject, JSTestExport {

	func test() {
		print("test successful!")
	}

}

class EKLanguageEngineTests: XCTestCase {

	let engine = EKJSCoreEngine()

	override func setUp() {
		super.setUp()
		currentNSBundle = NSBundle(forClass: EKFoundationFileManagerTests.self)
	}

	func testRunScript() {
		do {
			try engine.runScript(filename: "testScript")
		} catch {
			XCTFail()
		}
	}

	func testAddClass() {
		do {
			engine.addClass(JSTest)
			try engine.runScript(filename: "testClassScript")
		} catch {
			XCTFail()
		}
	}

}
