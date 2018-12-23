import Foundation
import Vapor

public protocol AnyResourceEditable {
    static func editRoute(parameter: PathComponent) -> [Routable]
}

public protocol ResourceEditable: AnyResourceEditable, Service, ResourceReflectable {
    associatedtype EditResponseType: ResponseEncodable
    
    func edit(_ request: Request) throws -> EditResponseType
}

extension ResourceEditable {
    static func editRoute(parameter: PathComponent) -> [Routable] {
        let edit = RouteEndpoint(pathComponents: [parameter, "edit"], method: .GET, closure: Self.edit)
        return [edit]
    }
}
