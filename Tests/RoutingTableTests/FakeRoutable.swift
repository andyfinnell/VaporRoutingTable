import Foundation
import Vapor
@testable import RoutingTable

class FakeRoutable: Routable {
    var register_wasCalled = false
    var register_wasCalled_withRouter: RuntimeRouter?
    func register(routes router: RuntimeRouter) {
        register_wasCalled = true
        register_wasCalled_withRouter = router
    }
}
