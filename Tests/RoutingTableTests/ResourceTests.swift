import Foundation
import Vapor
import XCTest
@testable import RoutingTable

class StubbedController: Service, ResourceReflectable {
    static var allRoutes_wasCalled = false
    static var allRoutes_wasCalled_withArgs: (parameter: PathComponent, only: [ResourceVerb], except: [ResourceVerb])?
    static var allRoutes_stubbed = [Routable]()
    static func allRoutes(parameter: PathComponent, only: [ResourceVerb], except: [ResourceVerb]) -> [Routable] {
        allRoutes_wasCalled = true
        allRoutes_wasCalled_withArgs = (parameter: parameter, only: only, except: except)
        return allRoutes_stubbed
    }
}

class ResourceTests: XCTestCase {
    var subject: Resource!
    var child: FakeRoutable!
    var middleware: FakeMiddleware!
    var verb: FakeRoutable!
    
    override func setUp() {
        super.setUp()
        
        verb = FakeRoutable()
        child = FakeRoutable()
        middleware = FakeMiddleware()
        StubbedController.allRoutes_stubbed = [verb]
        subject = Resource(pathComponents: ["toes"],
                           parameter: UUID.self,
                           middleware: [middleware],
                           controller: StubbedController.self,
                           only: ResourceVerb.allCases,
                           except: [.edit, .new],
                           children: [child])
    }
    
    func testRegister_childGotCorrectRouter() {
        let router = FakeRuntimeRouter()
        subject.register(routes: router)
        
        XCTAssertTrue(router.groupedPathComponents_wasCalled)
        let expectedPath: [PathComponent] = ["toes"]
        XCTAssertEqual(router.groupedPathComponents_wasCalled_withPathComponents!.convertToPathComponents(), expectedPath)
        
        let middlewareRouter = router.groupedPathComponents_stubbed
        XCTAssertTrue(middlewareRouter.groupedMiddleware_wasCalled)
        XCTAssertEqual(middlewareRouter.groupedMiddleware_wasCalled_withMiddleware!.count, 1)
        XCTAssertTrue(middlewareRouter.groupedMiddleware_wasCalled_withMiddleware![0] is FakeMiddleware)
        
        // validate verbs got the correct router
        XCTAssertTrue(StubbedController.allRoutes_wasCalled)
        XCTAssertEqual(StubbedController.allRoutes_wasCalled_withArgs!.parameter, UUID.parameter)
        XCTAssertEqual(StubbedController.allRoutes_wasCalled_withArgs!.only, ResourceVerb.allCases)
        XCTAssertEqual(StubbedController.allRoutes_wasCalled_withArgs!.except, [.edit, .new])
        XCTAssertTrue(verb.register_wasCalled)
        XCTAssertNotNil(verb.register_wasCalled_withRouter)
        let verbRouter = verb.register_wasCalled_withRouter as! FakeRuntimeRouter
        XCTAssertTrue(verbRouter === middlewareRouter.groupedMiddleware_stubbed)

        let childPathRouter = middlewareRouter.groupedMiddleware_stubbed
        XCTAssertTrue(childPathRouter.groupedPathComponents_wasCalled)
        let expectedChildPath: [PathComponent] = [UUID.parameter]
        XCTAssertEqual(childPathRouter.groupedPathComponents_wasCalled_withPathComponents!.convertToPathComponents(), expectedChildPath)

        // validate `children` got the correct `Router`
        XCTAssertTrue(child.register_wasCalled)
        XCTAssertNotNil(child.register_wasCalled_withRouter)
        let childRouter = child.register_wasCalled_withRouter as! FakeRuntimeRouter
        XCTAssertTrue(childRouter === childPathRouter.groupedPathComponents_stubbed)
    }
}
