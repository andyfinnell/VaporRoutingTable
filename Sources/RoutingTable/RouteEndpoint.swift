import Foundation
import Vapor

struct RouteEndpoint<C: Service, ResponseType: ResponseEncodable>: Routable {
    private let pathComponents: [PathComponentsRepresentable]
    private let method: HTTPMethod
    private let closure: (C) -> ((Request) throws -> ResponseType)
    
    init(pathComponents: [PathComponentsRepresentable], method: HTTPMethod, closure: @escaping (C) -> ((Request) throws -> ResponseType)) {
        self.pathComponents = pathComponents
        self.method = method
        self.closure = closure
    }

    func register(routes router: RuntimeRouter) {
        router.on(method, at: pathComponents) { request throws -> ResponseType in
            let controller = try request.make(C.self)
            let handler = self.closure(controller)
            return try handler(request)
        }
    }
}

extension RouteEndpoint: Equatable {
    static func ==(lhs: RouteEndpoint, rhs: RouteEndpoint) -> Bool {
        return lhs.pathComponents.convertToPathComponents() == rhs.pathComponents.convertToPathComponents()
            && lhs.method == rhs.method
    }
}
