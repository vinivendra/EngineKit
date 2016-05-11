import XCTest

#if os(iOS)
	@testable import EngineKitiOS
#endif
#if os(OSX)
	@testable import EngineKitOSX
#endif

class EKJSCoreEngineTests: XCTestCase {

	let engine = EKJSCoreEngine()

	func testOutput() {
		// Tests only if these functions don't crash... :/
		engine.context.evaluateScript("bla!")
		engine.context.evaluateScript("alert(\"alert!!\");")
		engine.context.evaluateScript("print(\"potato\");")
		engine.context.evaluateScript("console.log(\"potahto\");")
	}

	func testRunScript() {
		// Tests only if the function doesn't crash... :/
		engine.runScript(filename: "test.js")
	}

}
