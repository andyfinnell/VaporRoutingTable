import Foundation
import Vapor

public protocol RuntimeRouter {
    func grouped(_ pathComponents: [PathComponentsRepresentable]) -> RuntimeRouter
    func grouped(_ middleware: [Middleware]) -> RuntimeRouter
    func on<C, T>(_ method: HTTPMethod, _ content: C.Type, at path: PathComponentsRepresentable..., use closure: @escaping (Request, C) throws -> T)
        where C: RequestDecodable, T: ResponseEncodable
    func on<T>(_ method: HTTPMethod, at path: PathComponentsRepresentable..., use closure: @escaping (Request) throws -> T)
        where T: ResponseEncodable
}
