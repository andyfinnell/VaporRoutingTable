import Foundation
import Vapor

public protocol AnyResourceCreatable {
    static func createRoute() -> [Routable]
}

public protocol ResourceCreatable: AnyResourceCreatable, Service, ResourceReflectable {
    associatedtype CreateResponseType: ResponseEncodable
    associatedtype CreateRequestType: RequestDecodable
    
    func create(_ request: Request, parameters: CreateRequestType) throws -> CreateResponseType
}

public extension ResourceCreatable {
    public static func createRoute() -> [Routable] {
        let create = RouteEndpointWithParameters(pathComponents: [], method: .POST, closure: Self.create)
        return [create]
    }
}
