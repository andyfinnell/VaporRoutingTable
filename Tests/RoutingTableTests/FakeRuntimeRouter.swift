import Foundation
import Vapor
@testable import RoutingTable

class FakeRuntimeRouter: RuntimeRouter {
    var groupedPathComponents_wasCalled = false
    var groupedPathComponents_wasCalled_withPathComponents: [PathComponentsRepresentable]?
    lazy var groupedPathComponents_stubbed = FakeRuntimeRouter()
    func grouped(_ pathComponents: [PathComponentsRepresentable]) -> RuntimeRouter {
        groupedPathComponents_wasCalled = true
        groupedPathComponents_wasCalled_withPathComponents = pathComponents
        return groupedPathComponents_stubbed
    }
    
    var groupedMiddleware_wasCalled = false
    var groupedMiddleware_wasCalled_withMiddleware: [Middleware]?
    lazy var groupedMiddleware_stubbed = FakeRuntimeRouter()
    func grouped(_ middleware: [Middleware]) -> RuntimeRouter {
        groupedMiddleware_wasCalled = true
        groupedMiddleware_wasCalled_withMiddleware = middleware
        return groupedMiddleware_stubbed
    }
    
    var onContent_wasCalled = false
    var onContent_wasCalled_withArgs: (method: HTTPMethod, path: [PathComponentsRepresentable])?
    func on<C, T>(_ method: HTTPMethod, _ content: C.Type, at path: PathComponentsRepresentable..., use closure: @escaping (Request, C) throws -> T) where C : RequestDecodable, T : ResponseEncodable {
        onContent_wasCalled = true
        onContent_wasCalled_withArgs = (method: method, path: path)
    }
    
    var on_wasCalled = false
    var on_wasCalled_withArgs: (method: HTTPMethod, path: [PathComponentsRepresentable])?
    func on<T>(_ method: HTTPMethod, at path: PathComponentsRepresentable..., use closure: @escaping (Request) throws -> T) where T : ResponseEncodable {
        on_wasCalled = true
        on_wasCalled_withArgs = (method: method, path: path)
    }
}
