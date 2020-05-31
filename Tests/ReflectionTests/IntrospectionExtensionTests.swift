//
//  IntrospectionExtensionTests.swift
//
//  Copyright © 2020 Purgatory Design. All rights reserved.
//

#if canImport(ObjectiveC)

import Reflection
import XCTest

final class IntrospectionExtensionTests: XCTestCase {

    func testMethodNames() {
        let testClass = ObjCMembersTestClass()
        let actualNames = testClass.methodNames
        XCTAssertEqual(actualNames.sorted(), ["init", "testMethod"])
    }

    func testClassMethodNames() {
        let testClass = ObjCMembersTestClass()
        let actualNames = testClass.classMethodNames
        XCTAssertEqual(actualNames, ["classTestMethod"])
    }

    func testTestMethodNames() {
        let testClass = ObjCMembersTestClass()
        let actualNames = testClass.testMethodNames
        XCTAssertEqual(actualNames, ["testMethod"])
    }

    func testAllTestsArraySource() {
        let testClass = ObjCMembersTestClass()
        let actualSource = testClass.allTestsArraySource
        XCTAssertEqual(actualSource, "static var allTests = [\n\t(\"testMethod\", testMethod),\n]")
    }
}

extension IntrospectionExtensionTests {

    @objcMembers class ObjCMembersTestClass: NSObject {
        class func classTestMethod() {}
        func testMethod() {}
    }
}

#endif
