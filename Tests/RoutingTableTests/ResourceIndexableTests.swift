import Foundation
import Vapor
import XCTest
@testable import RoutingTable

class ResourceIndexableTests: XCTestCase {
    
    func testIndexRoutes() {
        let routes = FakeController.indexRoute()
        
        XCTAssertEqual(routes.count, 1)
        let typedRoutes = routes as! [RouteEndpoint<FakeController, FakeResponse>]
        let expectedRoutes = [
            RouteEndpoint(pathComponents: [], method: .GET, closure: FakeController.index),
            ]
        XCTAssertEqual(typedRoutes, expectedRoutes)
    }
}
