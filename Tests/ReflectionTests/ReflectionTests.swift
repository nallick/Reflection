//
//  ReflectionTests.swift
//
//  Copyright © 2020 Purgatory Design. All rights reserved.
//

import Reflection
import XCTest

final class ReflectionTests: XCTestCase {

    func testTypeKind() {
        let kind = Reflection.kind(of: TestBase.self)
        XCTAssertEqual(kind, .class)
    }

    func testTypeName() {
        let className = Reflection.name(of: TestBase.self)
        XCTAssertEqual(className, "TestBase")
    }

    func testTypeProperties() {
        let properties = Reflection.properties(of: TestClassFinal.self)
        let propertyNames = properties.map { $0.name }
        XCTAssertEqual(propertyNames, ["a", "b"])
    }

    func testEnumCases() {
        let cases = Reflection.enumCases(of: TestEnum.self)
        XCTAssertEqual(cases.sorted(), ["a", "b", "c"])
    }

    func testGenericTypes() {
        let genericTypes = Reflection.genericTypes(of: TestGeneric<Int, Double>.self)
        let genericTypeNames = genericTypes.map { Reflection.name(of: $0) }
        XCTAssertEqual(genericTypeNames, ["Int", "Double"])
    }

    func testSuperClass() {
        let superclass: AnyClass? = Reflection.superClass(of: TestClassIntermediate.self)
        let name = Reflection.name(of: superclass!)
        XCTAssertEqual(name, "TestBase")
    }

    func testSuperClasses() {
        let superclasses = Reflection.allSuperClasses(of: TestClassFinal.self)
        let names = superclasses.compactMap { Reflection.name(of: $0) }
        XCTAssertEqual(names, ["TestClassIntermediate", "TestBase"])
    }
}

#if canImport(ObjectiveC)

extension ReflectionTests {

    func testAllClasses() {
        let classNames = Reflection.allClasses
            .map { String(describing: $0) }
            .filter { $0 == "TestBase" || $0 == "TestConformingClass" }
        XCTAssertEqual(classNames.sorted(), ["TestBase", "TestConformingClass"])
    }

    func testConformsToProtocol() {
        XCTAssertTrue(Reflection.class(TestConformingClass.self, conformsTo: TestObjcProtocol.self))
        XCTAssertFalse(Reflection.class(TestNonConformingClass.self, conformsTo: TestObjcProtocol.self))
    }

    func testTypeMangledName() {
        let mangledClassName = Reflection.mangledName(of: TestBase.self)
        XCTAssertEqual(mangledClassName, "_TtCC15ReflectionTests15ReflectionTestsP33_1C1CFB621E44D76DD4D052C6350809528TestBase")
    }

    func testMethodNames() {
        let methodNames = Reflection.methodNames(of: TestNonConformingClass.self)
        XCTAssertEqual(methodNames.sorted(), ["init", "method1"])
    }
}

#endif

extension ReflectionTests {

    private enum TestEnum { case a, b, c(Int) }

    private struct TestGeneric<T1, T2> { let value1: T1; let value2: T2 }

    private class TestBase {}
    private class TestClassIntermediate: TestBase {}
    private class TestClassFinal: TestClassIntermediate { let a = 1; var b = 2 }


    #if canImport(ObjectiveC)
    private class TestConformingClass: NSObject, TestObjcProtocol {}
    private class TestNonConformingClass: NSObject { @objc func method1() {}; func method2() {} }
    #endif

    static var allTests = [
        ("testEnumCases", testEnumCases),
        ("testGenericTypes", testGenericTypes),
        ("testSuperClass", testSuperClass),
        ("testSuperClasses", testSuperClasses),
        ("testTypeKind", testTypeKind),
        ("testTypeName", testTypeName),
        ("testTypeProperties", testTypeProperties),
    ]
}

#if canImport(ObjectiveC)
@objc fileprivate protocol TestObjcProtocol {}
#endif
