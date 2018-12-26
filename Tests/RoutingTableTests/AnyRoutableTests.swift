import Foundation
import Vapor
import XCTest
@testable import RoutingTable


class AnyRoutableTests: XCTestCase {
    
    func testScope() {
        let child = FakeRoutable()
        let middleware = FakeMiddleware()
        let subject = AnyRoutable.scope("one", "two", "three", middleware: [middleware], children: [AnyRoutable(child)])

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
    
    func testResource_allVerbs() {
        let verb = FakeRoutable()
        let child = FakeRoutable()
        let middleware = FakeMiddleware()
        StubbedController.allRoutes_stubbed = [verb]
        let subject = AnyRoutable.resource("toes",
                           parameter: UUID.self,
                           middleware: [middleware],
                           using: StubbedController.self,
                           only: ResourceVerb.allCases,
                           except: [.edit, .new],
                           children: [AnyRoutable(child)])
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
    
    func testResource_noParameter() {
        let verb = FakeRoutable()
        let middleware = FakeMiddleware()
        StubbedController.allRoutes_stubbed = [verb]
        let subject = AnyRoutable.resource("toes",
                                           middleware: [middleware],
                                           using: StubbedController.self,
                                           only: ResourceVerb.allCases,
                                           except: [])
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
        XCTAssertEqual(StubbedController.allRoutes_wasCalled_withArgs!.parameter, None.parameter)
        XCTAssertEqual(StubbedController.allRoutes_wasCalled_withArgs!.only, ResourceVerb.allCases)
        XCTAssertEqual(StubbedController.allRoutes_wasCalled_withArgs!.except, [.show, .update, .delete, .edit])
        XCTAssertTrue(verb.register_wasCalled)
        XCTAssertNotNil(verb.register_wasCalled_withRouter)
        let verbRouter = verb.register_wasCalled_withRouter as! FakeRuntimeRouter
        XCTAssertTrue(verbRouter === middlewareRouter.groupedMiddleware_stubbed)
    }
    
    func testGet_noParameters() {
        let subject = AnyRoutable.get("one", "two", using: FakeController.show)

        let router = FakeRuntimeRouter()
        subject.register(routes: router)
        
        XCTAssertTrue(router.on_wasCalled)
        XCTAssertEqual(router.on_wasCalled_withArgs?.method, HTTPMethod.GET)
        let expectedPath: [PathComponent] = ["one", "two"]
        XCTAssertEqual(router.on_wasCalled_withArgs?.path.convertToPathComponents(), expectedPath)
    }
    
    func testGet_withParameters() {
        let subject = AnyRoutable.get("one", "two", using: FakeController.update)

        let router = FakeRuntimeRouter()
        subject.register(routes: router)
        
        XCTAssertTrue(router.onContent_wasCalled)
        XCTAssertEqual(router.onContent_wasCalled_withArgs?.method, HTTPMethod.GET)
        let expectedPath: [PathComponent] = ["one", "two"]
        XCTAssertEqual(router.onContent_wasCalled_withArgs?.path.convertToPathComponents(), expectedPath)
    }
    
    func testPut_noParameters() {
        let subject = AnyRoutable.put("one", "two", using: FakeController.show)
        
        let router = FakeRuntimeRouter()
        subject.register(routes: router)
        
        XCTAssertTrue(router.on_wasCalled)
        XCTAssertEqual(router.on_wasCalled_withArgs?.method, HTTPMethod.PUT)
        let expectedPath: [PathComponent] = ["one", "two"]
        XCTAssertEqual(router.on_wasCalled_withArgs?.path.convertToPathComponents(), expectedPath)
    }
    
    func testPut_withParameters() {
        let subject = AnyRoutable.put("one", "two", using: FakeController.update)
        
        let router = FakeRuntimeRouter()
        subject.register(routes: router)
        
        XCTAssertTrue(router.onContent_wasCalled)
        XCTAssertEqual(router.onContent_wasCalled_withArgs?.method, HTTPMethod.PUT)
        let expectedPath: [PathComponent] = ["one", "two"]
        XCTAssertEqual(router.onContent_wasCalled_withArgs?.path.convertToPathComponents(), expectedPath)
    }

    func testPatch_noParameters() {
        let subject = AnyRoutable.patch("one", "two", using: FakeController.show)
        
        let router = FakeRuntimeRouter()
        subject.register(routes: router)
        
        XCTAssertTrue(router.on_wasCalled)
        XCTAssertEqual(router.on_wasCalled_withArgs?.method, HTTPMethod.PATCH)
        let expectedPath: [PathComponent] = ["one", "two"]
        XCTAssertEqual(router.on_wasCalled_withArgs?.path.convertToPathComponents(), expectedPath)
    }
    
    func testPatch_withParameters() {
        let subject = AnyRoutable.patch("one", "two", using: FakeController.update)
        
        let router = FakeRuntimeRouter()
        subject.register(routes: router)
        
        XCTAssertTrue(router.onContent_wasCalled)
        XCTAssertEqual(router.onContent_wasCalled_withArgs?.method, HTTPMethod.PATCH)
        let expectedPath: [PathComponent] = ["one", "two"]
        XCTAssertEqual(router.onContent_wasCalled_withArgs?.path.convertToPathComponents(), expectedPath)
    }

    func testPost_noParameters() {
        let subject = AnyRoutable.post("one", "two", using: FakeController.show)
        
        let router = FakeRuntimeRouter()
        subject.register(routes: router)
        
        XCTAssertTrue(router.on_wasCalled)
        XCTAssertEqual(router.on_wasCalled_withArgs?.method, HTTPMethod.POST)
        let expectedPath: [PathComponent] = ["one", "two"]
        XCTAssertEqual(router.on_wasCalled_withArgs?.path.convertToPathComponents(), expectedPath)
    }
    
    func testPost_withParameters() {
        let subject = AnyRoutable.post("one", "two", using: FakeController.update)
        
        let router = FakeRuntimeRouter()
        subject.register(routes: router)
        
        XCTAssertTrue(router.onContent_wasCalled)
        XCTAssertEqual(router.onContent_wasCalled_withArgs?.method, HTTPMethod.POST)
        let expectedPath: [PathComponent] = ["one", "two"]
        XCTAssertEqual(router.onContent_wasCalled_withArgs?.path.convertToPathComponents(), expectedPath)
    }

    func testDelete_noParameters() {
        let subject = AnyRoutable.delete("one", "two", using: FakeController.show)
        
        let router = FakeRuntimeRouter()
        subject.register(routes: router)
        
        XCTAssertTrue(router.on_wasCalled)
        XCTAssertEqual(router.on_wasCalled_withArgs?.method, HTTPMethod.DELETE)
        let expectedPath: [PathComponent] = ["one", "two"]
        XCTAssertEqual(router.on_wasCalled_withArgs?.path.convertToPathComponents(), expectedPath)
    }
    
    func testDelete_withParameters() {
        let subject = AnyRoutable.delete("one", "two", using: FakeController.update)
        
        let router = FakeRuntimeRouter()
        subject.register(routes: router)
        
        XCTAssertTrue(router.onContent_wasCalled)
        XCTAssertEqual(router.onContent_wasCalled_withArgs?.method, HTTPMethod.DELETE)
        let expectedPath: [PathComponent] = ["one", "two"]
        XCTAssertEqual(router.onContent_wasCalled_withArgs?.path.convertToPathComponents(), expectedPath)
    }

}
