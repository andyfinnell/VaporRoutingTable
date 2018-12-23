import Foundation
import Vapor

public protocol Routable {
    func register(routes router: Router)
}

public struct AnyRoutable: Routable {
    private let impl: Routable
    
    init(_ impl: Routable) {
        self.impl = impl
    }
    
    public func register(routes router: Router) {
        impl.register(routes: router)
    }

    public static func scope(_ pathComponents: PathComponentsRepresentable..., middleware: [Middleware] = [], children: [AnyRoutable]) -> AnyRoutable {
        return AnyRoutable(Scope(pathComponents: pathComponents,
                     middleware: middleware,
                     children: children))
    }
    
    public static func resource<C, P>(_ pathComponents: PathComponentsRepresentable...,
        parameter: P.Type,
        middleware: [Middleware] = [],
        using controller: C.Type,
        only: [Resource.Verb] = Resource.Verb.allCases,
        except: [Resource.Verb] = [],
        children: [AnyRoutable] = []) -> AnyRoutable
        where C: Service, C: ResourceReflectable, P: Parameter {
        return AnyRoutable(Resource(pathComponents: pathComponents,
                                    parameter: parameter,
                                    middleware: middleware,
                                    controller: controller,
                                    only: only,
                                    except: except,
                                    children: children))
    }
    
    public static func resource<C>(_ pathComponents: PathComponentsRepresentable...,
        middleware: [Middleware] = [],
        using controller: C.Type,
        only: [Resource.Verb] = [.index, .create, .new],
        except: [Resource.Verb] = []) -> AnyRoutable
        where C: Service, C: ResourceReflectable {
        return AnyRoutable(Resource(pathComponents: pathComponents,
                                    parameter: None.self,
                                    middleware: middleware,
                                    controller: controller,
                                    only: only,
                                    except: except + [.show, .update, .delete, .edit],
                                    children: []))
    }

    public static func get<C: Service, ResponseType: ResponseEncodable>(_ pathComponents: PathComponentsRepresentable..., using closure: @escaping (C) -> ((Request) throws -> ResponseType)) -> AnyRoutable {
        return AnyRoutable(RouteEndpoint(pathComponents: pathComponents, method: .GET, closure: closure))
    }

    public static func put<C: Service, ResponseType: ResponseEncodable>(_ pathComponents: PathComponentsRepresentable..., using closure: @escaping (C) -> ((Request) throws -> ResponseType)) -> AnyRoutable {
        return AnyRoutable(RouteEndpoint(pathComponents: pathComponents, method: .PUT, closure: closure))
    }

    public static func patch<C: Service, ResponseType: ResponseEncodable>(_ pathComponents: PathComponentsRepresentable..., using closure: @escaping (C) -> ((Request) throws -> ResponseType)) -> AnyRoutable {
        return AnyRoutable(RouteEndpoint(pathComponents: pathComponents, method: .PATCH, closure: closure))
    }

    public static func post<C: Service, ResponseType: ResponseEncodable>(_ pathComponents: PathComponentsRepresentable..., using closure: @escaping (C) -> ((Request) throws -> ResponseType)) -> AnyRoutable {
        return AnyRoutable(RouteEndpoint(pathComponents: pathComponents, method: .POST, closure: closure))
    }

    public static func delete<C: Service, ResponseType: ResponseEncodable>(_ pathComponents: PathComponentsRepresentable..., using closure: @escaping (C) -> ((Request) throws -> ResponseType)) -> AnyRoutable {
        return AnyRoutable(RouteEndpoint(pathComponents: pathComponents, method: .DELETE, closure: closure))
    }

    public static func get<C: Service, ParametersType: RequestDecodable, ResponseType: ResponseEncodable>(_ pathComponents: PathComponentsRepresentable..., using closure: @escaping (C) -> ((Request, ParametersType) throws -> ResponseType)) -> AnyRoutable {
        return AnyRoutable(RouteEndpointWithParameters(pathComponents: pathComponents, method: .GET, closure: closure))
    }
    
    public static func put<C: Service, ParametersType: RequestDecodable, ResponseType: ResponseEncodable>(_ pathComponents: PathComponentsRepresentable..., using closure: @escaping (C) -> ((Request, ParametersType) throws -> ResponseType)) -> AnyRoutable {
        return AnyRoutable(RouteEndpointWithParameters(pathComponents: pathComponents, method: .PUT, closure: closure))
    }
    
    public static func patch<C: Service, ParametersType: RequestDecodable, ResponseType: ResponseEncodable>(_ pathComponents: PathComponentsRepresentable..., using closure: @escaping (C) -> ((Request, ParametersType) throws -> ResponseType)) -> AnyRoutable {
        return AnyRoutable(RouteEndpointWithParameters(pathComponents: pathComponents, method: .PATCH, closure: closure))
    }
    
    public static func post<C: Service, ParametersType: RequestDecodable, ResponseType: ResponseEncodable>(_ pathComponents: PathComponentsRepresentable..., using closure: @escaping (C) -> ((Request, ParametersType) throws -> ResponseType)) -> AnyRoutable {
        return AnyRoutable(RouteEndpointWithParameters(pathComponents: pathComponents, method: .POST, closure: closure))
    }
    
    public static func delete<C: Service, ParametersType: RequestDecodable, ResponseType: ResponseEncodable>(_ pathComponents: PathComponentsRepresentable..., using closure: @escaping (C) -> ((Request, ParametersType) throws -> ResponseType)) -> AnyRoutable {
        return AnyRoutable(RouteEndpointWithParameters(pathComponents: pathComponents, method: .DELETE, closure: closure))
    }
}
