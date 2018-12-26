import Foundation
import Vapor

public protocol AnyResourceIndexable {
    static func indexRoute() -> [Routable]
}

public protocol ResourceIndexable: AnyResourceIndexable, Service, ResourceReflectable {
    associatedtype IndexResponseType: ResponseEncodable
    
    func index(_ request: Request) throws -> IndexResponseType
}

extension ResourceIndexable {
    static func indexRoute() -> [Routable] {
        let index = RouteEndpoint(pathComponents: [], method: .GET, closure: Self.index)
        return [index]
    }
}
