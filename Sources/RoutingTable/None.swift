import Foundation
import Vapor

struct None: Parameter {
    typealias ResolvedParameter = Void

    static func resolveParameter(_ parameter: String, on container: Container) throws -> Void {
        // do nothing
    }
}
