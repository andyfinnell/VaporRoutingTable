import Foundation
import Vapor
import XCTest
@testable import RoutingTable

class ResourceCreatableTests: XCTestCase {
    
    func testCreateRoutes() {
        let routes = FakeController.createRoute()
        
        XCTAssertEqual(routes.count, 1)
        let typedRoutes = routes as! [RouteEndpointWithParameters<FakeController, FakeParameters, FakeResponse>]
        let expectedRoutes = [
            RouteEndpointWithParameters(pathComponents: [], method: .POST, closure: FakeController.create),
        ]
        XCTAssertEqual(typedRoutes, expectedRoutes)
    }
}
