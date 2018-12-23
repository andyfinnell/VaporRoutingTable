import Foundation
import Vapor

public struct RoutingTable {
    private let children: [AnyRoutable]
    
    public init(_ children: AnyRoutable...) {
        self.children = children
    }
    
    public func register(routes router: Router) {
        for child in children {
            child.register(routes: router)
        }
    }
}

