//
//  MirrorExtensions.swift
//
//  Copyright © 2017-2020 Purgatory Design. All rights reserved.
//

import BaseSwift
import Runtime

extension Mirror {

    public init(reflectingType type: Any.Type) {
        if let info = try? typeInfo(of: type) {
            if info.properties.isNotEmpty {
                let children = info.properties.map { ($0.name, Property(type: $0.type, byteOffset: $0.offset, isMutable: $0.isVar)) }
                self.init(type, children: children, displayStyle: .struct)
                return
            }

            if info.cases.isNotEmpty {
                let children = info.cases.map { ($0.name, [Any.Type]()) }
                self.init(type, children: children, displayStyle: .struct)
                return
            }
        }

        self.init(reflecting: type)
    }

    public static func properties(of value: Any) -> [String: Any] {
        Mirror(reflecting: value).children.reduce(into: [String: Any]()) { result, child in
            guard let label = child.0 else { return }
            result[label] = child.1
        }
    }
}

extension Mirror {

    public struct Property: Equatable {
        public let type: Any.Type
        public let byteOffset: Int
        public let isMutable: Bool

        public init(type: Any.Type, byteOffset: Int, isMutable: Bool) {
            self.type = type
            self.byteOffset = byteOffset
            self.isMutable = isMutable
        }

        public static func == (lhs: Mirror.Property, rhs: Mirror.Property) -> Bool {
            lhs.type == rhs.type && lhs.byteOffset == rhs.byteOffset && lhs.isMutable == rhs.isMutable
        }
    }
}
