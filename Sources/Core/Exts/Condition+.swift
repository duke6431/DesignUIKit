//
//  File.swift
//
//
//  Created by Duc Minh Nguyen on 9/1/24.
//

import Foundation

public protocol Conditionable {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` according to the condition.
    @discardableResult func `if`(_ condition: @autoclosure () -> Bool, transform: (Self) -> Self) -> Self

    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    ///   - else: The other transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` according to the condition.
    @discardableResult func `if`(_ condition: @autoclosure () -> Bool, transform: (Self) -> Self, else othertransform: ((Self) -> Self)) -> Self

    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - optional: Optional value as a condition.
    ///   - transform: The transform to apply to the source `View`.
    ///   - else: The other transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` according to the optional value.
    @discardableResult func `if`<T>(_ optional: T?, transform: (Self, T) -> Self) -> Self

    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - optional: Optional value as a condition.
    ///   - transform: The transform to apply to the source `View`.
    ///   - else: The other transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` according to the optional value.
    @discardableResult func `if`<T>(_ optional: T?, transform: (Self, T) -> Self, else othertransform: ((Self) -> Self)) -> Self

    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: Optional value as a condition.
    ///   - cases: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` according to the condition.
    @discardableResult func `switch`<T: Hashable>(_ condition: @autoclosure () -> T, cases: [T: (Self) -> Self]) -> Self

    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: Optional value as a condition.
    ///   - cases: The transform to apply to the source `View`.
    ///   - defalt: The other transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` according to the condition.
    @discardableResult func `switch`<T: Hashable>(_ condition: @autoclosure () -> T, cases: [T: (Self) -> Self], default transform: ((Self) -> Self)?) -> Self

    /// Applies the given transformation to view. Perfect to apply if else marco or platform available condition
    /// - Parameters:
    ///    - transform: The transformation to apply to the source `View`
    /// - Returns: View changed with transform
    @discardableResult func wrapped(transform: (Self) -> Self) -> Self
}

public extension Conditionable {
    @discardableResult func `if`(_ condition: @autoclosure () -> Bool, transform: (Self) -> Self) -> Self {
        if condition() {
            transform(self)
        } else {
            self
        }
    }

    @discardableResult func `if`(_ condition: @autoclosure () -> Bool, transform: (Self) -> Self, else othertransform: ((Self) -> Self)) -> Self {
        if condition() {
            transform(self)
        } else {
            othertransform(self)
        }
    }

    @discardableResult func `if`<T>(_ optional: T?, transform: (Self, T) -> Self) -> Self {
        if let optional {
            transform(self, optional)
        } else {
            self
        }
    }

    @discardableResult func `if`<T>(_ optional: T?, transform: (Self, T) -> Self, else othertransform: ((Self) -> Self)) -> Self {
        if let optional {
            transform(self, optional)
        } else {
            othertransform(self)
        }
    }

    @discardableResult func `switch`<T: Hashable>(_ condition: @autoclosure () -> T, cases: [T: (Self) -> Self]) -> Self {
        `switch`(condition(), cases: cases, default: nil)
    }

    @discardableResult func `switch`<T: Hashable>(_ condition: @autoclosure () -> T, cases: [T: (Self) -> Self], default transform: ((Self) -> Self)?) -> Self {
        if let action = cases[condition()] {
            action(self)
        } else if let transform {
            transform(self)
        } else {
            self
        }
    }

    @discardableResult func wrapped(transform: (Self) -> Self) -> Self {
        transform(self)
    }
}
