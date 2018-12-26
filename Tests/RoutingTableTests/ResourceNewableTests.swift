import Foundation
import Vapor
import XCTest
@testable import RoutingTable

class ResourceNewableTests: XCTestCase {
    
    func testNewRoutes() {
        let routes = FakeController.newRoute()
        
        XCTAssertEqual(routes.count, 1)
        let typedRoutes = routes as! [RouteEndpoint<FakeController, FakeResponse>]
        let expectedRoutes = [
            RouteEndpoint(pathComponents: ["new"], method: .GET, closure: FakeController.new),
            ]
        XCTAssertEqual(typedRoutes, expectedRoutes)
    }
}
