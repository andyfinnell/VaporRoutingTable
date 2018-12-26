import Foundation
import Vapor

struct Scope: Routable {
    private let pathComponents: [PathComponentsRepresentable]
    private let middleware: [Middleware]
    private let children: [Routable]
    
    init(pathComponents: [PathComponentsRepresentable], middleware: [Middleware], children: [Routable]) {
        self.pathComponents = pathComponents
        self.middleware = middleware
        self.children = children
    }
    
    func register(routes router: RuntimeRouter) {
        let subpath = router.grouped(pathComponents).grouped(middleware)
        for child in children {
            child.register(routes: subpath)
        }
    }
}

