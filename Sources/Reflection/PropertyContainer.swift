//
//  PropertyContainer.swift
//
//  Copyright © 2018-2020 Purgatory Design. All rights reserved.
//
//	Adds a properties dictionary to an object via reflection.
//

import Foundation

public protocol PropertyContainer {

	typealias Properties = [String: Any]
	var properties: Properties { get }
}

extension PropertyContainer {

	public var properties: [String: Any] {
        Mirror.properties(of: self)
	}
}

#if canImport(ObjectiveC)

extension NSObject: PropertyContainer {

    public var properties: [String: Any] {
        Mirror.properties(of: self)
    }
}

#endif
