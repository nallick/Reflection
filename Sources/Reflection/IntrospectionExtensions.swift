//
//  IntrospectionExtensions.swift
//
//  Copyright © 2017-2020 Purgatory Design. All rights reserved.
//

#if canImport(ObjectiveC)

import Foundation

public extension NSObject {

    var methodNames: [String] {
        Reflection.methodNames(of: type(of: self))
    }

    var classMethodNames: [String] {
        Reflection.methodNames(of: object_getClass(type(of: self)) as! NSObject.Type)
    }

    // for XCTest

    var testMethodNames: [String] {
        self.methodNames
            .filter { $0.hasPrefix("test") }
            .map { name in
                let throwingSuffix = "AndReturnError:"
                guard name.hasSuffix(throwingSuffix) else { return name }
                return String(name.dropLast(throwingSuffix.count))
            }
    }

    var allTestsArraySource: String {
        "static var allTests = [\n"
            + self.testMethodNames.sorted().map({ "\t(\"\($0)\", \($0)),\n" }).joined()
            + "]"
    }
}

#endif
