import Foundation
import Vapor
import XCTest
@testable import RoutingTable

class RouteEndpointTests: XCTestCase {
    var subject: RouteEndpoint<FakeController, FakeResponse>!
    
    override func setUp() {
        super.setUp()
        
        subject = RouteEndpoint(pathComponents: ["one", "two"], method: .GET, closure: FakeController.handler)
    }
    
    func testRegister() {
        let router = FakeRuntimeRouter()
        subject.register(routes: router)
        
        XCTAssertTrue(router.on_wasCalled)
        XCTAssertEqual(router.on_wasCalled_withArgs?.method, HTTPMethod.GET)
        let expectedPath: [PathComponent] = ["one", "two"]
        XCTAssertEqual(router.on_wasCalled_withArgs?.path.convertToPathComponents(), expectedPath)
    }
}
