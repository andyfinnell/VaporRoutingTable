import Foundation
import Vapor

class FakeMiddleware: Middleware {
    var response_wasCalled = false
    func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        response_wasCalled = true
        return try next.respond(to: request)
    }
}
