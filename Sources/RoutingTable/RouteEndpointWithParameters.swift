import Foundation
import Vapor

struct RouteEndpointWithParameters<C: Service, ParametersType: RequestDecodable, ResponseType: ResponseEncodable>: Routable {
    private let pathComponents: [PathComponentsRepresentable]
    private let method: HTTPMethod
    private let closure: (C) -> ((Request, ParametersType) throws -> ResponseType)
    
    init(pathComponents: [PathComponentsRepresentable], method: HTTPMethod, closure: @escaping (C) -> ((Request, ParametersType) throws -> ResponseType)) {
        self.pathComponents = pathComponents
        self.method = method
        self.closure = closure
    }
    
    func register(routes router: RuntimeRouter) {
        router.on(method, ParametersType.self, at: pathComponents) { request, parameters throws -> ResponseType in
            let controller = try request.make(C.self)
            let handler = self.closure(controller)
            return try handler(request, parameters)
        }
    }
}

extension RouteEndpointWithParameters: Equatable {
    static func ==(lhs: RouteEndpointWithParameters, rhs: RouteEndpointWithParameters) -> Bool {
        return lhs.pathComponents.convertToPathComponents() == rhs.pathComponents.convertToPathComponents()
            && lhs.method == rhs.method
    }
}
