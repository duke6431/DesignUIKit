//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 1/10/24.
//

import Foundation

public struct TestFailure: Error {
    var rawValue: String { String(describing: self) }
    var type: FailureType
    public var underlyingError: Error?
    public var note: String?
    
    init(type: FailureType, with underlyingError: Error? = nil, with note: String? = nil) {
        self.type = type
        self.underlyingError = underlyingError
        self.note = note
    }
    
    @discardableResult
    public func with<T>(_ property: WritableKeyPath<Self, T>, setTo value: T) -> Self {
        var newSelf = self
        newSelf[keyPath: property] = value
        return newSelf
    }
}
