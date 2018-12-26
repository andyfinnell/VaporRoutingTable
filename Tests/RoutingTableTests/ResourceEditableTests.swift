import Foundation
import Vapor
import XCTest
@testable import RoutingTable

class ResourceEditableTests: XCTestCase {
    
    func testEditRoutes() {
        let routes = FakeController.editRoute(parameter: UUID.parameter)
        
        XCTAssertEqual(routes.count, 1)
        let typedRoutes = routes as! [RouteEndpoint<FakeController, FakeResponse>]
        let expectedRoutes = [
            RouteEndpoint(pathComponents: [UUID.parameter, "edit"], method: .GET, closure: FakeController.edit),
            ]
        XCTAssertEqual(typedRoutes, expectedRoutes)
    }
}
