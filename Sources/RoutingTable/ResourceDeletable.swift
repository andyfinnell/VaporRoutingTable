import Foundation
import Vapor

public protocol AnyResourceDeletable {
    static func deleteRoute(parameter: PathComponent) -> [Routable]
}

public protocol ResourceDeletable: AnyResourceDeletable, Service, ResourceReflectable {
    associatedtype DeleteResponseType: ResponseEncodable
    
    func delete(_ request: Request) throws -> DeleteResponseType
}

extension ResourceDeletable {
    static func deleteRoute(parameter: PathComponent) -> [Routable] {
        let delete = RouteEndpoint(pathComponents: [parameter], method: .DELETE, closure: Self.delete)
        return [delete]
    }
}
