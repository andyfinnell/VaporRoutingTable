import Foundation
import Vapor

extension PathComponent: Equatable {
    public static func ==(lhs: PathComponent, rhs: PathComponent) -> Bool {
        switch (lhs, rhs) {
        case let (.constant(lhsValue), .constant(rhsValue)):
            return lhsValue == rhsValue
        case let (.parameter(lhsValue), .parameter(rhsValue)):
            return lhsValue == rhsValue
        case (.anything, .anything):
            return true
        case (.catchall, .catchall):
            return true
        default:
            return false
        }
    }
}
