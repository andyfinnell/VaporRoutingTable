import Foundation
import Vapor
import XCTest
@testable import RoutingTable

struct FakeParameters: Content {
    
}

class RouteEndpointWithParametersTests: XCTestCase {
    var subject: RouteEndpointWithParameters<FakeController, FakeParameters, FakeResponse>!
    
    override func setUp() {
        super.setUp()
        
        subject = RouteEndpointWithParameters(pathComponents: ["one", "two"], method: .GET, closure: FakeController.handler)
    }
    
    func testRegister() {
        let router = FakeRuntimeRouter()
        subject.register(routes: router)
        
        XCTAssertTrue(router.onContent_wasCalled)
        XCTAssertEqual(router.onContent_wasCalled_withArgs?.method, HTTPMethod.GET)
        let expectedPath: [PathComponent] = ["one", "two"]
        XCTAssertEqual(router.onContent_wasCalled_withArgs?.path.convertToPathComponents(), expectedPath)
    }
}
