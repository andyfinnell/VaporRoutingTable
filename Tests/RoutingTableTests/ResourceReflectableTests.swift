import Foundation
import Vapor
import XCTest
@testable import RoutingTable

class ResourceReflectableTests: XCTestCase {
    
    func testAllRoutes_allOnly_noExcept() {
        let routes = FakeController.allRoutes(parameter: UUID.parameter, only: ResourceVerb.allCases, except: [])
        
        XCTAssertEqual(routes.count, 8)
        XCTAssertTrue(routes.contains(where: matches(RouteEndpointWithParameters(pathComponents: [UUID.parameter], method: .PUT, closure: FakeController.update))))
        XCTAssertTrue(routes.contains(where: matches(RouteEndpointWithParameters(pathComponents: [UUID.parameter], method: .PATCH, closure: FakeController.update))))
        XCTAssertTrue(routes.contains(where: matches(RouteEndpoint(pathComponents: [UUID.parameter], method: .GET, closure: FakeController.show))))
        XCTAssertTrue(routes.contains(where: matches(RouteEndpoint(pathComponents: ["new"], method: .GET, closure: FakeController.new))))
        XCTAssertTrue(routes.contains(where: matches(RouteEndpoint(pathComponents: [], method: .GET, closure: FakeController.index))))
        XCTAssertTrue(routes.contains(where: matches(RouteEndpoint(pathComponents: [UUID.parameter, "edit"], method: .GET, closure: FakeController.edit))))
        XCTAssertTrue(routes.contains(where: matches(RouteEndpoint(pathComponents: [UUID.parameter], method: .DELETE, closure: FakeController.delete))))
        XCTAssertTrue(routes.contains(where: matches(RouteEndpointWithParameters(pathComponents: [], method: .POST, closure: FakeController.create))))
    }
    
    func testAllRoutes_noOnly_allExcept() {
        let routes = FakeController.allRoutes(parameter: UUID.parameter, only: [], except: ResourceVerb.allCases)
        
        XCTAssertEqual(routes.count, 0)
    }
    
    func testAllRoutes_someOnly_noExcept() {
        let routes = FakeController.allRoutes(parameter: UUID.parameter, only: [.show, .index, .create], except: [])

        XCTAssertEqual(routes.count, 3)
        XCTAssertTrue(routes.contains(where: matches(RouteEndpoint(pathComponents: [UUID.parameter], method: .GET, closure: FakeController.show))))
        XCTAssertTrue(routes.contains(where: matches(RouteEndpoint(pathComponents: [], method: .GET, closure: FakeController.index))))
        XCTAssertTrue(routes.contains(where: matches(RouteEndpointWithParameters(pathComponents: [], method: .POST, closure: FakeController.create))))
    }
    
    func testAllRoutes_allOnly_someExcept() {
        let routes = FakeController.allRoutes(parameter: UUID.parameter, only: ResourceVerb.allCases, except: [.edit, .new])
        
        XCTAssertEqual(routes.count, 6)
        XCTAssertTrue(routes.contains(where: matches(RouteEndpointWithParameters(pathComponents: [UUID.parameter], method: .PUT, closure: FakeController.update))))
        XCTAssertTrue(routes.contains(where: matches(RouteEndpointWithParameters(pathComponents: [UUID.parameter], method: .PATCH, closure: FakeController.update))))
        XCTAssertTrue(routes.contains(where: matches(RouteEndpoint(pathComponents: [UUID.parameter], method: .GET, closure: FakeController.show))))
        XCTAssertTrue(routes.contains(where: matches(RouteEndpoint(pathComponents: [], method: .GET, closure: FakeController.index))))
        XCTAssertTrue(routes.contains(where: matches(RouteEndpoint(pathComponents: [UUID.parameter], method: .DELETE, closure: FakeController.delete))))
        XCTAssertTrue(routes.contains(where: matches(RouteEndpointWithParameters(pathComponents: [], method: .POST, closure: FakeController.create))))
    }
    
    private func matches<T: Equatable>(_ value: T) -> ((Routable) -> Bool) {
        return { (element: Routable) -> Bool in
            guard let typedElement = element as? T else {
                return false
            }
            return typedElement == value
        }
    }
}
