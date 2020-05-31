import XCTest

#if !canImport(ObjectiveC)

public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(MirrorExtensionTests.allTests),
        testCase(ReflectionTests.allTests),
    ]
}

#endif
