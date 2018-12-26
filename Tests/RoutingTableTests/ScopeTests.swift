import Foundation
import Vapor
import XCTest
@testable import RoutingTable


class ScopeTests: XCTestCase {
    var subject: Scope!
    var child: FakeRoutable!
    var middleware: FakeMiddleware!
    
    override func setUp() {
        super.setUp()
        
        child = FakeRoutable()
        middleware = FakeMiddleware()
        subject = Scope(pathComponents: ["one", "two", "three"], middleware: [middleware], children: [child])
    }
    
    func testRegister_childGotCorrectRouter() {
        let router = FakeRuntimeRouter()
        subject.register(routes: router)
        
        XCTAssertTrue(router.groupedPathComponents_wasCalled)
        let expectedPath: [PathComponent] = ["one", "two", "three"]
        XCTAssertEqual(router.groupedPathComponents_wasCalled_withPathComponents!.convertToPathComponents(), expectedPath)
        
        let middlewareRouter = router.groupedPathComponents_stubbed
        XCTAssertTrue(middlewareRouter.groupedMiddleware_wasCalled)
        XCTAssertEqual(middlewareRouter.groupedMiddleware_wasCalled_withMiddleware!.count, 1)
        XCTAssertTrue(middlewareRouter.groupedMiddleware_wasCalled_withMiddleware![0] is FakeMiddleware)

        // validate `children` got the correct `Router`
        XCTAssertTrue(child.register_wasCalled)
        XCTAssertNotNil(child.register_wasCalled_withRouter)
        let childRouter = child.register_wasCalled_withRouter as! FakeRuntimeRouter
        XCTAssertTrue(childRouter === middlewareRouter.groupedMiddleware_stubbed)
    }
}
