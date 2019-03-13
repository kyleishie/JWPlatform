import XCTest
@testable import JWPlatform

final class JWPlatformTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(JWPlatform().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
