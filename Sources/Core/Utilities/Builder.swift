//
//  Builder.swift
//  DesignCore
//
//  Created by Duc IT. Nguyen Minh on 07/01/2023.
//

import Foundation

/**
 A protocol that enables an object to be configured using chainable methods.
 
 This protocol is intended for reference types (`AnyObject`) to allow fluent configuration
 by returning `self` after applying changes.
 */
@objc public protocol Chainable { }

public extension Chainable where Self: AnyObject {
    /**
     Sets a property of the object to a given value and returns the object itself.
     
     This method allows for chaining multiple property assignments in a fluent style.
     
     - Parameters:
     - property: A `ReferenceWritableKeyPath` to the property to set.
     - value: The value to assign to the property.
     
     - Returns: The object itself after setting the property.
     */
    @discardableResult
    func with<T>(_ property: ReferenceWritableKeyPath<Self, T>, setTo value: T) -> Self {
        self[keyPath: property] = value
        return self
    }
    
    /**
     Applies a custom configuration closure to the object and returns the object itself.
     
     This method allows for arbitrary configuration of the object in a chainable manner.
     
     - Parameter configuration: A closure that takes the object as a parameter for configuration.
     
     - Returns: The object itself after applying the configuration.
     */
    @discardableResult
    func customized(_ configuration: (Self) -> Void) -> Self {
        configuration(self)
        return self
    }
}

/**
 A protocol that enables value types to be customized by returning modified copies.
 
 This protocol is intended for value types (e.g., structs) to support functional-style updates
 by returning a new instance with applied changes.
 */
public protocol SelfCustomizable {
    /**
     Returns a modified copy of the instance after applying the given configuration closure.
     
     - Parameter configuration: A closure that takes an `inout` copy of the instance to modify.
     
     - Returns: A new instance with the modifications applied.
     */
    @discardableResult
    func custom(_ configuration: (inout Self) -> Void) -> Self
    
    /**
     Returns a modified copy of the instance with the specified property updated to a new value.
     
     - Parameters:
     - keyPath: A writable key path to the property to update.
     - value: The new value to assign to the property.
     
     - Returns: A new instance with the updated property.
     */
    @discardableResult
    func updated<Value>(_ keyPath: WritableKeyPath<Self, Value>, with value: Value) -> Self
}

public extension SelfCustomizable {
    @discardableResult
    func custom(_ configuration: (inout Self) -> Void) -> Self {
        var newSelf = self
        configuration(&newSelf)
        return newSelf
    }
    
    @discardableResult
    func updated<Value>(_ keyPath: WritableKeyPath<Self, Value>, with value: Value) -> Self {
        var newSelf = self
        newSelf[keyPath: keyPath] = value
        return newSelf
    }
}
