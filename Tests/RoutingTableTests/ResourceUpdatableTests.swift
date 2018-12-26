import Foundation
import Vapor
import XCTest
@testable import RoutingTable

class ResourceUpdatableTests: XCTestCase {
    
    func testUpdateRoutes() {
        let routes = FakeController.updateRoute(parameter: UUID.parameter)
        
        XCTAssertEqual(routes.count, 2)
        let typedRoutes = routes as! [RouteEndpointWithParameters<FakeController, FakeParameters, FakeResponse>]
        let expectedRoutes = [
            RouteEndpointWithParameters(pathComponents: [UUID.parameter], method: .PUT, closure: FakeController.update),
            RouteEndpointWithParameters(pathComponents: [UUID.parameter], method: .PATCH, closure: FakeController.update)
        ]
        XCTAssertEqual(typedRoutes, expectedRoutes)
    }
}
