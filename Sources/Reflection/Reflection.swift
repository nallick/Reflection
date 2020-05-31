//
//  Reflection.swift
//
//  Copyright © 2018-2020 Purgatory Design. All rights reserved.
//

import Runtime

public enum Reflection {

    public static func kind(of type: Any.Type) -> Kind? {
        guard let info = try? typeInfo(of: type) else { return nil }
        return info.kind
    }

    public static func name(of type: Any.Type) -> String {
        return String(describing: type)
    }

//  This doesn't appear to be mangled.
//
//    public static func mangledName(of type: Any.Type) -> String? {
//        guard let info = try? typeInfo(of: type) else { return nil }
//        return info.mangledName
//    }

    public static func enumCases(of type: Any.Type) -> [String] {
        guard let info = try? typeInfo(of: type) else { return [] }
        return info.cases.map { $0.name }
    }

    public static func properties(of type: Any.Type) -> [PropertyInfo] {
        guard let info = try? typeInfo(of: type) else { return [] }
        return info.properties
    }

    public static func genericTypes(of type: Any.Type) -> [Any.Type] {
        guard let info = try? typeInfo(of: type) else { return [] }
        return info.genericTypes
    }

    public static func superClass(of aClass: AnyClass) -> AnyClass? {
        guard let info = try? typeInfo(of: aClass) else { return nil }
        return info.superClass as? AnyClass
    }

    public static func allSuperClasses(of aClass: AnyClass) -> [AnyClass] {
        guard let info = try? typeInfo(of: aClass) else { return [] }
        return info.inheritance.compactMap { $0 as? AnyClass }
    }
}

#if canImport(ObjectiveC)

import Foundation

extension Reflection {

    /// A list of all available classes that exist at the first time this is called.
    ///
    /// - Note: Any classes added dynamically after that first call won't be reflected here.
    ///
    public static let allClasses: [AnyClass] = {
        Reflection.allExistingClasses
    }()

    /// A list of all available classes at the current time.
    ///
    public static var allExistingClasses: [AnyClass] {
        var count: UInt32 = 0
        guard let classList = objc_copyClassList(&count) else { return [] }
        let classListBuffer = UnsafeBufferPointer(start: classList, count: Int(count))
        defer { classListBuffer.deallocate() }
        return classListBuffer.map { $0 }
    }

    @inlinable public static func `class`(_ aClass: AnyClass, conformsTo objcProtocol: Protocol) -> Bool {
        class_conformsToProtocol(aClass, objcProtocol)
    }

    @inlinable public static func mangledName(of aClass: AnyClass) -> String {
        String(cString: class_getName(aClass))
    }

    /// Get a list of all Obj-C methods of a class.
    ///
    /// - Parameter type: The class type.
    /// - Returns: The method name list.
    ///
    public static func methodNames(of aClass: AnyClass) -> [String] {
        var methodNames = [String]()

        var count: CUnsignedInt = 0
        var list: UnsafeMutablePointer<Method>? = class_copyMethodList(aClass, &count)
        for _ in 0 ..< count {
            methodNames.append(String(describing: method_getName((list?.pointee)!)))
            list = list?.successor()
        }

        return methodNames
    }
}

#endif
