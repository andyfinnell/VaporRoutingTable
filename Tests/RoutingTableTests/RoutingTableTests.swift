import XCTest
@testable import RoutingTable

final class RoutingTableTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(RoutingTable().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
