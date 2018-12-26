import Foundation
import Vapor
@testable import RoutingTable

class FakeController: Service {
    func handler(_ request: Request) throws -> FakeResponse {
        return FakeResponse()
    }
    
    func handler(_ request: Request, parameters: FakeParameters) throws -> FakeResponse {
        return FakeResponse()
    }
}

extension FakeController: ResourceUpdatable {
    func update(_ request: Request, parameters: FakeParameters) throws -> FakeResponse {
        return FakeResponse()
    }
}

extension FakeController: ResourceShowable {
    func show(_ request: Request) throws -> FakeResponse {
        return FakeResponse()
    }
}

extension FakeController: ResourceNewable {
    func new(_ request: Request) throws -> FakeResponse {
        return FakeResponse()
    }
}

extension FakeController: ResourceIndexable {
    func index(_ request: Request) throws -> FakeResponse {
        return FakeResponse()
    }
}

extension FakeController: ResourceEditable {
    func edit(_ request: Request) throws -> FakeResponse {
        return FakeResponse()
    }
}

extension FakeController: ResourceDeletable {
    func delete(_ request: Request) throws -> FakeResponse {
        return FakeResponse()
    }
}

extension FakeController: ResourceCreatable {
    func create(_ request: Request, parameters: FakeParameters) throws -> FakeResponse {
        return FakeResponse()
    }
}
