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
@objc class JSTest: NSObject, JSTestExport, Scriptable, Initable {

	override required init() {
		super.init()
	}

	func test() {
		print("test successful!")
	}

}

class EKJSCoreEngineTests: XCTestCase {

	var engine: EKJSCoreEngine!
	var ekEngine: EKEngine!

	override func setUp() {
		super.setUp()

		ekEngine = EKEngine()
		engine = EKJSCoreEngine(engine: ekEngine)
		ekEngine.languageEngine = engine

		currentNSBundle = NSBundle(forClass: EKJSCoreEngineTests.self)
	}

	func testOutput() {
		// Tests only if these functions don't crash... :/
		engine.context.evaluateScript("alert(\"alert!!\");")
		engine.context.evaluateScript("print(\"print!!\");")
		engine.context.evaluateScript("console.log(\"console.log!!\");")
		XCTAssertNil(engine.evaluationError)
	}

	func testRunScript() {
		do {
			try engine.runScript(filename: "testScript")
		} catch {
			XCTFail()
		}

		do {
			try engine.runScript(filename: "testScriptFail")
			XCTFail()
		} catch { }
	}

	func testAddClass() {
		do {
			engine.addClass(JSTest.self,
			                withName: "EKTest",
			                constructor: JSTest.init)
			try engine.runScript(filename: "testClassScript")
		} catch {
			XCTFail()
		}
	}

}
