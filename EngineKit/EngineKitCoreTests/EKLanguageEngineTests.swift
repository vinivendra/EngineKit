import XCTest

#if os(iOS)
	@testable import EngineKitiOS
#endif
#if os(OSX)
	@testable import EngineKitOSX
#endif

class EKLanguageEngineTests: XCTestCase {

	func testToEKPrefixClassName() {
		XCTAssertEqual("SCNSphere".toEKPrefixClassName(), "EKSphere")
	}

}
