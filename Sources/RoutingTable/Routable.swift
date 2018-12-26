import Foundation
import Vapor

public protocol Routable {
    func register(routes router: RuntimeRouter)
}
