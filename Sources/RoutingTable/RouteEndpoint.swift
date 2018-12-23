import Foundation
import Vapor

struct RouteEndpointWithParameters<C: Service, ParametersType: RequestDecodable, ResponseType: ResponseEncodable>: Routable {
    let pathComponents: [PathComponentsRepresentable]
    let method: HTTPMethod
    let closure: (C) -> ((Request, ParametersType) throws -> ResponseType)
    
    func register(routes router: Router) {
        router.on(method, ParametersType.self, at: pathComponents) { request, parameters throws -> ResponseType in
            let controller = try request.make(C.self)
            let handler = self.closure(controller)
            return try handler(request, parameters)
        }
    }
}

struct RouteEndpoint<C: Service, ResponseType: ResponseEncodable>: Routable {
    let pathComponents: [PathComponentsRepresentable]
    let method: HTTPMethod
    let closure: (C) -> ((Request) throws -> ResponseType)
    
    func register(routes router: Router) {
        router.on(method, at: pathComponents) { request throws -> ResponseType in
            let controller = try request.make(C.self)
            let handler = self.closure(controller)
            return try handler(request)
        }
    }
}
