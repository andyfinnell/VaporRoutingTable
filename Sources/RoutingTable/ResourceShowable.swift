import Foundation
import Vapor

public protocol AnyResourceShowable {
    static func showRoute(parameter: PathComponent) -> [Routable]
}

public protocol ResourceShowable: AnyResourceShowable, Service, ResourceReflectable {
    associatedtype ShowResponseType: ResponseEncodable
    
    func show(_ request: Request) throws -> ShowResponseType
}

extension ResourceShowable {
    static func showRoute(parameter: PathComponent) -> [Routable] {
        let show = RouteEndpoint(pathComponents: [parameter], method: .GET, closure: Self.show)
        return [show]
    }
}
