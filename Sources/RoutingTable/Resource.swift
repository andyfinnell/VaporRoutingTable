import Foundation
import Vapor

public struct Resource: Routable {
    private let pathComponents: [PathComponentsRepresentable]
    private let parameter: PathComponent
    private let middleware: [Middleware]
    private let children: [Routable]
    private let verbs: [Routable]
    
    public enum Verb: Hashable, CaseIterable {
        case index, show, create, update, delete, new, edit
    }
    
    init<C, P>(pathComponents: [PathComponentsRepresentable],
                          parameter: P.Type,
                          middleware: [Middleware],
                          controller: C.Type,
                          only: [Verb],
                          except: [Verb],
                          children: [Routable])
        where C: Service, C: ResourceReflectable, P: Parameter
    {
        self.pathComponents = pathComponents
        self.parameter = P.parameter
        self.middleware = middleware
        self.children = children
        self.verbs = controller.allRoutes(parameter: P.parameter, only: only, except: except)
    }
    
    public func register(routes router: Router) {
        let subpath = router.grouped(pathComponents).grouped(middleware)
        for verb in verbs {
            verb.register(routes: subpath)
        }
        let childPath = subpath.grouped(parameter)
        for child in children {
            child.register(routes: childPath)
        }
    }
}

