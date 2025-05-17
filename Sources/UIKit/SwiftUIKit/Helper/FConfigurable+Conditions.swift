//
//  FConfigurable+Conditions.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2024/02/20.
//
//  Provides conditional view transformation utilities for FConfigurable views.
//  Includes support for `if`, `if-else`, and `switch` style declarative modifiers.
//

import UIKit
import DesignCore

public extension FConfigurable where Self: UIView {
    /// Applies the given transform if the condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: A Boolean expression to evaluate.
    ///   - transform: A closure that returns a modified view when the condition is `true`.
    /// - Returns: The original or transformed view based on the condition.
    @discardableResult func `if`<Content: FBodyComponent>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> FBodyComponent {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
    
    /// Applies one of two transforms depending on the result of a Boolean condition.
    /// - Parameters:
    ///   - condition: A Boolean expression to evaluate.
    ///   - transform: The closure to apply if the condition is `true`.
    ///   - othertransform: The closure to apply if the condition is `false`.
    /// - Returns: A view transformed by one of the closures depending on the condition.
    @discardableResult func `if`<Content: FBodyComponent, OtherContent: FBodyComponent>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content, else othertransform: ((Self) -> OtherContent)) -> FBodyComponent {
        if condition() {
            transform(self)
        } else {
            othertransform(self)
        }
    }
    
    /// Applies a transform using a non-nil optional value.
    /// - Parameters:
    ///   - optional: An optional value. If non-nil, the transform is applied.
    ///   - transform: A closure that takes the optional value and returns a modified view.
    /// - Returns: A transformed view if the optional is non-nil, otherwise the original view.
    @discardableResult func `if`<T, Content: FBodyComponent>(_ optional: T?, transform: (Self, T) -> Content) -> FBodyComponent {
        if let optional {
            transform(self, optional)
        } else {
            self
        }
    }
    
    /// Applies a transform using a non-nil optional value, or an alternate transform if nil.
    /// - Parameters:
    ///   - optional: An optional value.
    ///   - transform: A closure that uses the non-nil value.
    ///   - othertransform: A closure used when the optional is `nil`.
    /// - Returns: The view transformed accordingly.
    @discardableResult func `if`<T, Content: FBodyComponent, OtherContent: FBodyComponent>(_ optional: T?, transform: (Self, T) -> Content, else othertransform: ((Self) -> OtherContent)) -> FBodyComponent {
        if let optional {
            transform(self, optional)
        } else {
            othertransform(self)
        }
    }
    
    /// Applies a transformation based on the value of a condition matched against a dictionary of cases.
    /// - Parameters:
    ///   - condition: A hashable condition to match against provided cases.
    ///   - cases: A dictionary mapping values to transform closures.
    ///   - transform: An optional default transform if no case matches.
    /// - Returns: The transformed view from the matched case or default, or the original view.
    @discardableResult func `switch`<T: Hashable, Content: FBodyComponent>(_ condition: @autoclosure () -> T, cases: [T: (Self) -> FBodyComponent], default transform: ((Self) -> Content)? = nil) -> FBodyComponent {
        if let action = cases[condition()] {
            action(self)
        } else if let transform {
            transform(self)
        } else {
            self
        }
    }
    
    /// Applies a transformation to the view without any condition.
    /// Ideal for macro-like `#if` or `#available` platform logic.
    /// - Parameter transform: A closure that returns the transformed view.
    /// - Returns: The transformed view.
    @discardableResult func wrapped<Content: FBodyComponent>(transform: (Self) -> Content) -> FBodyComponent {
        transform(self)
    }
}
