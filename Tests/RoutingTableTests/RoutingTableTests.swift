import XCTest
import Vapor
@testable import RoutingTable

class RoutingTableTests: XCTestCase {
    var subject: RoutingTable!
    var child1: FakeRoutable!
    var child2: FakeRoutable!

    override func setUp() {
        super.setUp()
        
        child1 = FakeRoutable()
        child2 = FakeRoutable()
        subject = RoutingTable(AnyRoutable(child1), AnyRoutable(child2))
    }
    
    func testRegister() {
        let router = FakeRuntimeRouter()
        subject.register(routes: router)

        // validate `children` got the correct `Router`
        XCTAssertTrue(child1.register_wasCalled)
        XCTAssertNotNil(child1.register_wasCalled_withRouter)
        let child1Router = child1.register_wasCalled_withRouter as! FakeRuntimeRouter
        XCTAssertTrue(child1Router === router)

        XCTAssertTrue(child2.register_wasCalled)
        XCTAssertNotNil(child2.register_wasCalled_withRouter)
        let child2Router = child2.register_wasCalled_withRouter as! FakeRuntimeRouter
        XCTAssertTrue(child2Router === router)
    }
}
