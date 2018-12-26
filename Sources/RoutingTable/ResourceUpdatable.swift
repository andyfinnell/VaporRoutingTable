import Foundation
import Vapor

public protocol AnyResourceUpdatable {
    static func updateRoute(parameter: PathComponent) -> [Routable]
}

public protocol ResourceUpdatable: AnyResourceUpdatable, Service, ResourceReflectable {
    associatedtype UpdateResponseType: ResponseEncodable
    associatedtype UpdateRequestType: RequestDecodable
    
    func update(_ request: Request, parameters: UpdateRequestType) throws -> UpdateResponseType
}

extension ResourceUpdatable {
    static func updateRoute(parameter: PathComponent) -> [Routable] {
        let update1 = RouteEndpointWithParameters(pathComponents: [parameter], method: .PUT, closure: Self.update)
        let update2 = RouteEndpointWithParameters(pathComponents: [parameter], method: .PATCH, closure: Self.update)
        return [update1, update2]
    }
}
