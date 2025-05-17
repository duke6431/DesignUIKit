//
//  Condition+.swift
//  DesignUIKit
//
//  Created by Duc Minh Nguyen on 9/1/24.
//
//  This file defines the `Conditionable` protocol and its default implementations,
//  allowing conditional transformations using fluent chaining syntax.
//  It is especially useful in declarative UI builders such as SwiftUI.

import Foundation

public protocol Conditionable {
    /// Applies the given transform if the condition evaluates to `true`.
    ///
    /// - Parameters:
    ///   - condition: A Boolean value to evaluate.
    ///   - transform: A closure to apply if the condition is true.
    /// - Returns: The original or transformed instance depending on the condition.
    @discardableResult func `if`(_ condition: @autoclosure () -> Bool, transform: (Self) -> Self) -> Self
    
    /// Applies one of two transforms depending on whether the condition evaluates to `true`.
    ///
    /// - Parameters:
    ///   - condition: A Boolean value to evaluate.
    ///   - transform: A closure to apply if the condition is true.
    ///   - othertransform: A closure to apply if the condition is false.
    /// - Returns: The result of either transform.
    @discardableResult func `if`(_ condition: @autoclosure () -> Bool, transform: (Self) -> Self, else othertransform: ((Self) -> Self)) -> Self
    
    /// Applies the given transform if the optional contains a value.
    ///
    /// - Parameters:
    ///   - optional: An optional value.
    ///   - transform: A closure that uses the unwrapped value to transform `self`.
    /// - Returns: The original or transformed instance depending on whether the optional is `nil`.
    @discardableResult func `if`<T>(_ optional: T?, transform: (Self, T) -> Self) -> Self
    
    /// Applies one of two transforms depending on whether the optional contains a value.
    ///
    /// - Parameters:
    ///   - optional: An optional value.
    ///   - transform: A closure that uses the unwrapped value to transform `self`.
    ///   - othertransform: A closure to apply if the optional is `nil`.
    /// - Returns: The result of either transform.
    @discardableResult func `if`<T>(_ optional: T?, transform: (Self, T) -> Self, else othertransform: ((Self) -> Self)) -> Self
    
    /// Applies a transform based on matching a value to a dictionary of cases.
    ///
    /// - Parameters:
    ///   - condition: A value to evaluate.
    ///   - cases: A dictionary mapping values to their corresponding transforms.
    /// - Returns: The transformed result if a match is found, or `self` otherwise.
    @discardableResult func `switch`<T: Hashable>(_ condition: @autoclosure () -> T, cases: [T: (Self) -> Self]) -> Self
    
    /// Applies a transform based on matching a value to a dictionary of cases, or a default transform if no match is found.
    ///
    /// - Parameters:
    ///   - condition: A value to evaluate.
    ///   - cases: A dictionary mapping values to their corresponding transforms.
    ///   - transform: A default closure to apply if no match is found.
    /// - Returns: The result of the matched transform or the default transform.
    @discardableResult func `switch`<T: Hashable>(_ condition: @autoclosure () -> T, cases: [T: (Self) -> Self], default transform: ((Self) -> Self)?) -> Self
    
    /// Applies a transformation to `self`, useful for wrapping conditional or platform-specific logic.
    ///
    /// - Parameter transform: A closure that transforms `self`.
    /// - Returns: The transformed instance.
    @discardableResult func wrapped(transform: (Self) -> Self) -> Self
}

public extension Conditionable {
    /// Applies the given transform if the condition is `true`.
    ///
    /// - Parameters:
    ///   - condition: A Boolean value that determines whether the transform is applied.
    ///   - transform: A closure that transforms `self` if the condition is true.
    /// - Returns: Either the original or transformed `Self`, depending on the condition.
    @discardableResult
    func `if`(_ condition: @autoclosure () -> Bool, transform: (Self) -> Self) -> Self {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
    
    /// Applies the given transform if the condition is `true`, otherwise applies the alternate transform.
    ///
    /// - Parameters:
    ///   - condition: A Boolean value to evaluate.
    ///   - transform: A closure to apply if the condition is true.
    ///   - othertransform: A closure to apply if the condition is false.
    /// - Returns: The result of either `transform` or `othertransform`.
    @discardableResult
    func `if`(_ condition: @autoclosure () -> Bool, transform: (Self) -> Self, else othertransform: ((Self) -> Self)) -> Self {
        if condition() {
            transform(self)
        } else {
            othertransform(self)
        }
    }
    
    /// Applies the transform if the optional contains a value.
    ///
    /// - Parameters:
    ///   - optional: An optional value.
    ///   - transform: A closure that uses the unwrapped value to transform `self`.
    /// - Returns: Either the original or transformed `Self`.
    @discardableResult
    func `if`<T>(_ optional: T?, transform: (Self, T) -> Self) -> Self {
        if let optional {
            transform(self, optional)
        } else {
            self
        }
    }
    
    /// Applies the transform if the optional contains a value, otherwise applies the alternate transform.
    ///
    /// - Parameters:
    ///   - optional: An optional value.
    ///   - transform: A closure that transforms `self` using the unwrapped value.
    ///   - othertransform: A closure that transforms `self` if the optional is `nil`.
    /// - Returns: The result of either `transform` or `othertransform`.
    @discardableResult
    func `if`<T>(_ optional: T?, transform: (Self, T) -> Self, else othertransform: ((Self) -> Self)) -> Self {
        if let optional {
            transform(self, optional)
        } else {
            othertransform(self)
        }
    }
    
    /// Applies a transformation based on the value of the condition using the provided cases.
    ///
    /// - Parameters:
    ///   - condition: A value to evaluate.
    ///   - cases: A dictionary mapping values to their corresponding transformations.
    /// - Returns: The result of the matched case transformation or `self` if no match.
    @discardableResult
    func `switch`<T: Hashable>(_ condition: @autoclosure () -> T, cases: [T: (Self) -> Self]) -> Self {
        `switch`(condition(), cases: cases, default: nil)
    }
    
    /// Applies a transformation based on the value of the condition using the provided cases, or a default if no match is found.
    ///
    /// - Parameters:
    ///   - condition: A value to evaluate.
    ///   - cases: A dictionary of possible values and their transformations.
    ///   - transform: A default transformation if no match is found.
    /// - Returns: The result of the matched case or the default transformation, or `self` if none apply.
    @discardableResult
    func `switch`<T: Hashable>(_ condition: @autoclosure () -> T, cases: [T: (Self) -> Self], default transform: ((Self) -> Self)?) -> Self {
        if let action = cases[condition()] {
            action(self)
        } else if let transform {
            transform(self)
        } else {
            self
        }
    }
    
    /// Wraps the current value with a transformation.
    ///
    /// - Parameter transform: A closure that transforms `self`.
    /// - Returns: The transformed `Self`.
    @discardableResult
    func wrapped(transform: (Self) -> Self) -> Self {
        transform(self)
    }
}
