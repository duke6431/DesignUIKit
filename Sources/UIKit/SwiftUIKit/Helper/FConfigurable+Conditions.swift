//
//  File.swift
//
//
//  Created by Duc Minh Nguyen on 2/20/24.
//

import UIKit
import DesignCore

public extension FConfigurable where Self: UIView {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` according to the condition.
    @discardableResult func `if`<Content: FBodyComponent>(
        _ condition: @autoclosure () -> Bool,
        transform: (Self) -> Content
    ) -> FBodyComponent {
        if condition() {
            transform(self)
        } else {
            self
        }
    }

    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    ///   - else: The other transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` according to the condition.
    @discardableResult func `if`<Content: FBodyComponent, OtherContent: FBodyComponent>(
        _ condition: @autoclosure () -> Bool,
        transform: (Self) -> Content,
        else othertransform: ((Self) -> OtherContent)
    ) -> FBodyComponent {
        if condition() {
            transform(self)
        } else {
            othertransform(self)
        }
    }

    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - optional: Optional value as a condition.
    ///   - transform: The transform to apply to the source `View`.
    ///   - else: The other transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` according to the optional value.
    @discardableResult func `if`<T, Content: FBodyComponent>(
        _ optional: T?,
        transform: (Self, T) -> Content
    ) -> FBodyComponent {
        if let optional {
            transform(self, optional)
        } else {
            self
        }
    }

    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - optional: Optional value as a condition.
    ///   - transform: The transform to apply to the source `View`.
    ///   - else: The other transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` according to the optional value.
    @discardableResult func `if`<T, Content: FBodyComponent, OtherContent: FBodyComponent>(
        _ optional: T?,
        transform: (Self, T) -> Content,
        else othertransform: ((Self) -> OtherContent)) -> FBodyComponent {
        if let optional {
            transform(self, optional)
        } else {
            othertransform(self)
        }
    }

    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - optional: Optional value as a condition.
    ///   - cases: The transform to apply to the source `View`.
    ///   - defalt: The other transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` according to the condition.
    @discardableResult func `switch`<T: Hashable, Content: FBodyComponent>(
        _ condition: @autoclosure () -> T,
        cases: [T: (Self) -> FBodyComponent],
        default transform: ((Self) -> Content)? = nil
    ) -> FBodyComponent {
        if let action = cases[condition()] {
            action(self)
        } else if let transform {
            transform(self)
        } else {
            self
        }
    }

    /// Applies the given transformation to view. Perfect to apply if else marco or platform available condition
    /// - Parameters:
    ///    - transform: The transformation to apply to the source `View`
    /// - Returns: View changed with transform
    @discardableResult func wrapped<Content: FBodyComponent>(
        transform: (Self) -> Content
    ) -> FBodyComponent {
        transform(self)
    }
}
