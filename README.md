# RoutingTable

`RoutingTable` is a declarative routing library for use with the [Vapor](https://github.com/vapor/vapor) server-side Swift web framework. `RoutingTable` allows you to  set up routes like this:

```Swift
import Vapor
import RoutingTable

public func routes(_ router: Router) throws {
    let table = RoutingTable(
        .scope("api", middleware: [ApiKeyMiddleware()], children: [
            .resource("users", parameter: User.self, using: UserController.self, children: [
                .resource("sprockets", parameter: Sprocket.self, using: SprocketController.self),
                .resource("widgets", using: WidgetController.self)
            ]),
            .resource("sessions", using: SessionController.self),
            .post("do_stuff", using: StuffController.doStuff)
        ])
    )
    table.register(routes: router)
}
```

`RoutingTable` defines the routes with high level concepts like `scopes` and `resources`,  and structures them hierarchically.

## Installation

`RoutingTable` is installed via the [Swift Package Manager](https://github.com/apple/swift-package-manager). To add it to your project, modify the `Package.swift` file to include it as a dependency:

```Swift
// ...snip...
let package = Package(
    // ...snip...
    dependencies: [
        // ...snip...
        // Add this line:
        .package(url: "https://github.com/andyfinnell/VaporRoutingTable.git", from: "0.0.1")
    ],
    targets: [
        .target(name: "App", dependencies: [
            // ...snip...
            // Add this line:
            "RoutingTable"
            ]),
        // ...snip...
    ]
)
```

## Configuration

The `RoutingTable` library layers on top of the `Vapor` framework to make it easier to declare and maintain routes. Most of the information needed to set up the routes `RoutingTable` can infer based on Swift types, but there are couple of configuration steps that need to be taken before `RoutingTable` can be used.

First, `RoutingTable` needs to be able to create controllers at runtime so they can handle their assigned routes. Vapor's `Services` dependency injection framework is leveraged to do this. As a result, all controllers need to conform to the `Service` protocol and be registered with the dependency injection framework.

One straight forward way to accomplish this is to conform the controllers to `ServiceType`:

```Swift
final class MyAPIController {
    // ...snip...
}

extension MyAPIController: ServiceType {
    static func makeService(for worker: Container) throws -> MyAPIController {
        return MyAPIController()
    }
}
```

And then in `configure()` register it:

```Swift
services.register(MyAPIController.self)
```

The second part of configuration is modifying the `routes.swift` file to use `RoutingTable`:

```Swift
import Vapor
import RoutingTable 

public func routes(_ router: Router) throws {
    let table = RoutingTable(
        // Your routes go here
    )
    table.register(routes: router)
}
```

There are two steps to be done. First, declaring all your routes using `RoutingTable` (see below for how to do that). And second, registering all of those declared routes onto Vapor's `Router` using `RoutingTable.register(routes:)`.

There a three kinds of routes that can be declared using `RoutingTable`: scopes, resources, and raw endpoints.
 
## Scopes

A scope is useful for grouping routes together under a common path prefix and/or middleware. For example, it can be used to group API functionality or admin functionality together.

Using the API example:

```Swift
let table = RoutingTable(
    .scope("api", middleware: [ApiKeyMiddleware()], children: [
        // Put any API resources or endpoints here
    ])
)
```

All routes under the `scope` declared here will be prefixed with the "api" path and be processed by the `ApiKeyMiddleware`.

Scopes can be nested and can overlap each other's path prefixes, as long as they don't declare the same endpoints. For example:

```Swift
let table = RoutingTable(
    .scope("api", middleware: [ApiKeyMiddleware()], children: [
        .post("register", using: RegisterController.register)
    ]),
    .scope("api", middleware: [AuthenticationMiddleware()], children: [
        .post("change_password", using: PasswordController.update)
    ]),
)
```

Since the endpoints declared above are different, the routing table is valid. 

## Resources

`RoutingTable` allows REST-like resources to be modeled directly in the routes. Resources can be nested, and can support any of the following operations: index, show, create, update, delete, new, and edit. When a resource is declared, `RoutingTable` will inspect the type and determine which of the operations is supported by the controller, and automatically register those routes. 

```Swift
let table = RoutingTable(
    .resource("users", parameter: User.self, using: UserController.self, children: [])
)
```

This requires some type support from the controller, in the form of conforming to the correct protocol. For example, if a controller supports the show operation, it must conform to the `ResourceShowable` protocol:

```Swift
extension UserController: ResourceShowable {    
    func show(_ request: Request) throws -> Future<Response> {
        // logic for showing here
    }
}
```

The `show(_:)` method above will be registered as a handler for the `GET /users/:user_id` route for this example.

This table shows each operation, the required protocol, and the routes the operation registers:

| Operation | Protocol | Routes |
|---------------|------------|------------|
| index | `ResourceIndexable` | GET /users |
| show | `ResourceShowable` | GET /users/:user_id |
| create | `ResourceCreatable` | POST /users |
| update | `ResourceUpdatable` | PUT /users/:user_id  and PATCH /users/:user_id |
| delete | `ResourceDeletable` | DELETE /users/:user_id |
| new | `ResourceNewable` | GET /users/new |
| edit | `ResourceEditable` | GET /users/:user_id/edit |

`RoutingTable` allows you to select which of the operations supported by a controller are registered. This can be useful in the case where a resource is declared at two different locations  and should support different operations in each. An example of this could be  a normal user's API vs. an admin user's API. The `resource()` method accepts the `only` and `except` parameters to restrict the operations to a subset of the controller's supported operations.

For example this would only register routes for the create and new operations:

```Swift
let table = RoutingTable(
    .resource("users", parameter: User.self, using: UserController.self, only: [.create, .new], children: [])
)
```

This example would register routes for all supported operations, except delete:

```Swift
let table = RoutingTable(
    .resource("users", parameter: User.self, using: UserController.self, except: [.delete], children: [])
)
```

## Raw Endpoints

`RoutingTable` also allows you to declare HTTP endpoints directly, which is useful for endpoints that are not REST-like. All the main HTTP methods are available: GET, PUT, PATCH, POST, DELETE. Simply declare the method and path you want handled, and `RoutingTable` with infer the parameters, if any, from the provided handler.

```Swift
public func routes(_ router: Router) throws {
    let table = RoutingTable(
        .post("do_stuff", using: StuffController.doStuff)
    )
    table.register(routes: router)
}
```

```Swift
final class StuffController {
    struct Parameters: Content {
        let parameter1: Bool
        let parameter2: String
    }
    
    func doStuff(_ request: Request, parameters: Parameters) throws -> Future<MyResponse> {
        // ...your logic goes here...
    }
}
```