import XCTest

extension AnyRoutableTests {
    static let __allTests = [
        ("testDelete_noParameters", testDelete_noParameters),
        ("testDelete_withParameters", testDelete_withParameters),
        ("testGet_noParameters", testGet_noParameters),
        ("testGet_withParameters", testGet_withParameters),
        ("testPatch_noParameters", testPatch_noParameters),
        ("testPatch_withParameters", testPatch_withParameters),
        ("testPost_noParameters", testPost_noParameters),
        ("testPost_withParameters", testPost_withParameters),
        ("testPut_noParameters", testPut_noParameters),
        ("testPut_withParameters", testPut_withParameters),
        ("testResource_allVerbs", testResource_allVerbs),
        ("testResource_noParameter", testResource_noParameter),
        ("testScope", testScope),
    ]
}

extension ResourceCreatableTests {
    static let __allTests = [
        ("testCreateRoutes", testCreateRoutes),
    ]
}

extension ResourceDeletableTests {
    static let __allTests = [
        ("testDeleteRoutes", testDeleteRoutes),
    ]
}

extension ResourceEditableTests {
    static let __allTests = [
        ("testEditRoutes", testEditRoutes),
    ]
}

extension ResourceIndexableTests {
    static let __allTests = [
        ("testIndexRoutes", testIndexRoutes),
    ]
}

extension ResourceNewableTests {
    static let __allTests = [
        ("testNewRoutes", testNewRoutes),
    ]
}

extension ResourceReflectableTests {
    static let __allTests = [
        ("testAllRoutes_allOnly_noExcept", testAllRoutes_allOnly_noExcept),
        ("testAllRoutes_allOnly_someExcept", testAllRoutes_allOnly_someExcept),
        ("testAllRoutes_noOnly_allExcept", testAllRoutes_noOnly_allExcept),
        ("testAllRoutes_someOnly_noExcept", testAllRoutes_someOnly_noExcept),
    ]
}

extension ResourceShowableTests {
    static let __allTests = [
        ("testShowRoutes", testShowRoutes),
    ]
}

extension ResourceTests {
    static let __allTests = [
        ("testRegister_childGotCorrectRouter", testRegister_childGotCorrectRouter),
    ]
}

extension ResourceUpdatableTests {
    static let __allTests = [
        ("testUpdateRoutes", testUpdateRoutes),
    ]
}

extension RouteEndpointTests {
    static let __allTests = [
        ("testRegister", testRegister),
    ]
}

extension RouteEndpointWithParametersTests {
    static let __allTests = [
        ("testRegister", testRegister),
    ]
}

extension RoutingTableTests {
    static let __allTests = [
        ("testRegister", testRegister),
    ]
}

extension ScopeTests {
    static let __allTests = [
        ("testRegister_childGotCorrectRouter", testRegister_childGotCorrectRouter),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AnyRoutableTests.__allTests),
        testCase(ResourceCreatableTests.__allTests),
        testCase(ResourceDeletableTests.__allTests),
        testCase(ResourceEditableTests.__allTests),
        testCase(ResourceIndexableTests.__allTests),
        testCase(ResourceNewableTests.__allTests),
        testCase(ResourceReflectableTests.__allTests),
        testCase(ResourceShowableTests.__allTests),
        testCase(ResourceTests.__allTests),
        testCase(ResourceUpdatableTests.__allTests),
        testCase(RouteEndpointTests.__allTests),
        testCase(RouteEndpointWithParametersTests.__allTests),
        testCase(RoutingTableTests.__allTests),
        testCase(ScopeTests.__allTests),
    ]
}
#endif
