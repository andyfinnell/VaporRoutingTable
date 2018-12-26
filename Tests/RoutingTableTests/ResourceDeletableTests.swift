import Foundation
import Vapor
import XCTest
@testable import RoutingTable

class ResourceDeletableTests: XCTestCase {
    
    func testDeleteRoutes() {
        let routes = FakeController.deleteRoute(parameter: UUID.parameter)
        
        XCTAssertEqual(routes.count, 1)
        let typedRoutes = routes as! [RouteEndpoint<FakeController, FakeResponse>]
        let expectedRoutes = [
            RouteEndpoint(pathComponents: [UUID.parameter], method: .DELETE, closure: FakeController.delete)
        ]
        XCTAssertEqual(typedRoutes, expectedRoutes)
    }
}
