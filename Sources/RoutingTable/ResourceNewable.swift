import Foundation
import Vapor

public protocol AnyResourceNewable {
    static func newRoute() -> [Routable]
}

public protocol ResourceNewable: AnyResourceNewable, Service, ResourceReflectable {
    associatedtype NewResponseType: ResponseEncodable
    
    func new(_ request: Request) throws -> NewResponseType
}

extension ResourceNewable {
    static func newRoute() -> [Routable] {
        let new = RouteEndpoint(pathComponents: ["new"], method: .GET, closure: Self.new)
        return [new]
    }
}
