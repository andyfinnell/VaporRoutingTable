import Foundation
import Vapor

struct VaporRuntimeRouter: RuntimeRouter {
    private let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func grouped(_ pathComponents: [PathComponentsRepresentable]) -> RuntimeRouter {
        return VaporRuntimeRouter(router: router.grouped(pathComponents))
    }
    
    func grouped(_ middleware: [Middleware]) -> RuntimeRouter {
        return VaporRuntimeRouter(router: router.grouped(middleware))
    }
    
    func on<C, T>(_ method: HTTPMethod, _ content: C.Type, at path: PathComponentsRepresentable..., use closure: @escaping (Request, C) throws -> T)
        where C: RequestDecodable, T: ResponseEncodable {
            router.on(method, content, at: path, use: closure)
    }
    
    func on<T>(_ method: HTTPMethod, at path: PathComponentsRepresentable..., use closure: @escaping (Request) throws -> T)
        where T: ResponseEncodable {
            router.on(method, at: path, use: closure)
    }
}
