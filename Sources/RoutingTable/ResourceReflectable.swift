import Foundation
import Vapor

public protocol ResourceReflectable {
    static func allRoutes(parameter: PathComponent, only: [ResourceVerb], except: [ResourceVerb]) -> [Routable]
}

extension ResourceReflectable {
    static func allRoutes(parameter: PathComponent, only: [ResourceVerb], except: [ResourceVerb]) -> [Routable] {
        let verbs = Set(only).subtracting(except)
        let index = ResourceReflectableSupport.cast(Self.self, to: AnyResourceIndexable.Type.self, if: .index, in: verbs) { $0.indexRoute() }
        
        let show = ResourceReflectableSupport.cast(Self.self, to: AnyResourceShowable.Type.self, if: .show, in: verbs) { $0.showRoute(parameter: parameter) }
        
        let create = ResourceReflectableSupport.cast(Self.self, to: AnyResourceCreatable.Type.self, if: .create, in: verbs) { $0.createRoute() }
        
        let update = ResourceReflectableSupport.cast(Self.self, to: AnyResourceUpdatable.Type.self, if: .update, in: verbs) { $0.updateRoute(parameter: parameter) }
        
        let delete = ResourceReflectableSupport.cast(Self.self, to: AnyResourceDeletable.Type.self, if: .delete, in: verbs) { $0.deleteRoute(parameter: parameter) }
        
        let new = ResourceReflectableSupport.cast(Self.self, to: AnyResourceNewable.Type.self, if: .new, in: verbs) { $0.newRoute() }
        
        let edit = ResourceReflectableSupport.cast(Self.self, to: AnyResourceEditable.Type.self, if: .edit, in: verbs) { $0.editRoute(parameter: parameter) }
        
        return index + show + create + update + delete + new + edit
    }
}

private struct ResourceReflectableSupport {
    static func cast<F, T>(_ fromType: F, to toType: T.Type, if verb: ResourceVerb, in supportedVerbs: Set<ResourceVerb>, closure: (T) -> [Routable]) -> [Routable] {
        guard let typeInstance = fromType as? T, supportedVerbs.contains(verb) else {
            return []
        }
        return closure(typeInstance)
    }
}
