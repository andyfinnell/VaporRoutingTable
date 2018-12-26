import Foundation
import Vapor
import XCTest
@testable import RoutingTable

class ResourceShowableTests: XCTestCase {
    
    func testShowRoutes() {
        let routes = FakeController.showRoute(parameter: UUID.parameter)
        
        XCTAssertEqual(routes.count, 1)
        let typedRoutes = routes as! [RouteEndpoint<FakeController, FakeResponse>]
        let expectedRoutes = [
            RouteEndpoint(pathComponents: [UUID.parameter], method: .GET, closure: FakeController.show),
        ]
        XCTAssertEqual(typedRoutes, expectedRoutes)
    }
}
