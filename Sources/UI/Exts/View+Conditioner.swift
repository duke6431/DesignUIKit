//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 1/7/24.
//

import SwiftUI

public extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` according to the condition.
    @ViewBuilder
    func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
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
    @ViewBuilder
    func `if`<Content: View, OtherContent: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content, else othertransform: ((Self) -> OtherContent)) -> some View {
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
    @ViewBuilder
    func `if`<T, Content: View>(_ optional: T?, transform: (Self, T) -> Content) -> some View {
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
    @ViewBuilder
    func `if`<T, Content: View, OtherContent: View>(_ optional: T?, transform: (Self, T) -> Content, else othertransform: ((Self) -> OtherContent)) -> some View {
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
    @ViewBuilder
    func `switch`<T: Hashable, Content: View>(_ condition: @autoclosure () -> T, cases: [T: (Self) -> some View], default transform: ((Self) -> Content)? = nil) -> some View {
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
    @ViewBuilder
    func wrapped<Content: View>(transform: (Self) -> Content) -> some View {
        transform(self)
    }
}
