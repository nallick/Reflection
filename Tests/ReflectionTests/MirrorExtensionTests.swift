//
//  MirrorExtensionTests.swift
//
//  Copyright © 2020 Purgatory Design. All rights reserved.
//

import Reflection
import XCTest

final class MirrorExtensionTests: XCTestCase {

    func testMirrorReflectingStruct() {
        let mirror = Mirror(reflectingType: TestPropertyContainer.self)
        let expectedLabels = ["a", "b", "c"]
        let expectedProperties = [
            Mirror.Property(type: Optional<Int>.self, byteOffset: 0, isMutable: true),
            Mirror.Property(type: Optional<Int>.self, byteOffset: 16, isMutable: false),
            Mirror.Property(type: Optional<Int>.self, byteOffset: 32, isMutable: false),
        ]

        let actualLabels = mirror.children.map { $0.0! }
        let actualProperties = mirror.children.map { $0.1 as! Mirror.Property }

        XCTAssertEqual(actualLabels, expectedLabels)
        XCTAssertEqual(actualProperties, expectedProperties)
    }

    func testMirrorReflectingClass() {
        let mirror = Mirror(reflectingType: TestPropertyContainerClass.self)
        let expectedLabels = ["a", "b", "c"]
        let expectedProperties = [
            Mirror.Property(type: Int.self, byteOffset: 16, isMutable: false),
            Mirror.Property(type: Int.self, byteOffset: 24, isMutable: false),
            Mirror.Property(type: Int.self, byteOffset: 32, isMutable: true),
        ]

        let actualLabels = mirror.children.map { $0.0! }
        let actualProperties = mirror.children.map { $0.1 as! Mirror.Property }

        XCTAssertEqual(actualLabels, expectedLabels)
        XCTAssertEqual(actualProperties, expectedProperties)
    }

    func testMirrorReflectingEnum() {
        let mirror = Mirror(reflectingType: TestPropertyContainerEnum.self)
        let expectedLabels = ["a", "b", "c"]
        let expectedProperties: [[Any.Type]] = [[], [], []]

        let actualLabels = mirror.children.map { $0.0! }
        let actualProperties = mirror.children.map { $0.1 as! [Any.Type] }

        XCTAssertEqual(actualLabels.sorted(), expectedLabels)
        XCTAssertEqual(actualProperties.flatMap({ $0 }).count, expectedProperties.flatMap({ $0 }).count)
        XCTAssertEqual(actualProperties.flatMap({ $0 }).count, 0)
    }

    func testPropertyContainerStruct() {
        let testStruct = TestPropertyContainer(a: 1, b: 2, c: 3)
        let actualProperties = testStruct.properties as! [String: Int]
        XCTAssertEqual(actualProperties, ["a": 1, "b": 2, "c": 3])
    }

    func testPropertyContainerClass() {
        let testObject = TestPropertyContainerClass()
        let actualProperties = testObject.properties as! [String: Int]
        XCTAssertEqual(actualProperties, ["a": 1, "b": 2, "c": 3])
    }

    func testPropertyContainerObject() {
        let testObject = TestPropertyContainerObject()
        let actualProperties = testObject.properties as! [String: Int]
        XCTAssertEqual(actualProperties, ["a": 1, "b": 2, "c": 3])
    }

    func testPropertyContainerEnum() {
        let actualProperties1 = TestPropertyContainerEnum.a.properties
        let actualProperties2 = TestPropertyContainerEnum.c(123).properties as! [String: Int]
        XCTAssertTrue(actualProperties1.isEmpty)
        XCTAssertEqual(actualProperties2, ["c": 123])
    }

    func testPropertyContainerTuple() {
        let testTupleLabeled = (a: 1, b: 2, c: 3)
        let testTupleUnlabeled = (1, 2, 3)
        let actualPropertiesLabeled = Mirror.properties(of: testTupleLabeled) as! [String: Int]
        let actualPropertiesUnlabeled = Mirror.properties(of: testTupleUnlabeled) as! [String: Int]
        XCTAssertEqual(actualPropertiesLabeled, ["a": 1, "b": 2, "c": 3])
        XCTAssertEqual(actualPropertiesUnlabeled, [".0": 1, ".1": 2, ".2": 3])
    }
}

extension MirrorExtensionTests {

    private struct TestPropertyContainer: PropertyContainer {
        var a: Int?; let b, c: Int?
    }

    private class TestPropertyContainerClass: PropertyContainer {
        let a, b: Int; var c: Int
        init() {a = 1; b = 2; c = 3}
    }

    private class TestPropertyContainerObject: NSObject {
        let a, b, c: Int
        override init() {a = 1; b = 2; c = 3}
    }

    private enum TestPropertyContainerEnum: PropertyContainer {
        case a, b, c(Int)
    }

    static var allTests = [
        ("testMirrorReflectingClass", testMirrorReflectingClass),
        ("testMirrorReflectingEnum", testMirrorReflectingEnum),
        ("testMirrorReflectingStruct", testMirrorReflectingStruct),
        ("testPropertyContainerClass", testPropertyContainerClass),
        ("testPropertyContainerEnum", testPropertyContainerEnum),
        ("testPropertyContainerObject", testPropertyContainerObject),
        ("testPropertyContainerStruct", testPropertyContainerStruct),
        ("testPropertyContainerTuple", testPropertyContainerTuple),
    ]
}
