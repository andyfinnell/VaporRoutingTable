import Foundation
import Vapor

public struct RoutingTable {
    private let children: [AnyRoutable]
    
    public init(_ children: AnyRoutable...) {
        self.children = children
    }
    
    public func register(routes router: Router) {
        register(routes: VaporRuntimeRouter(router: router))
    }
    
    func register(routes router: RuntimeRouter) {
        for child in children {
            child.register(routes: router)
        }
    }
}

