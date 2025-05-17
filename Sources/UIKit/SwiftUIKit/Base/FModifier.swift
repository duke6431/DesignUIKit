//
//  FModifier.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2024/09/27.
//
//  Defines the `FModifier` protocol for applying transformation logic to body components
//  in a chainable UI system.
//

import Foundation

/// A protocol that defines a modifier for transforming a UI component's body.
/// Typically used to apply additional configuration or appearance logic to `FBodyComponent`s.
public protocol FModifier {
    /// The type of content this modifier operates on, usually an `FBodyComponent`.
    typealias Content = FBodyComponent
    
    /// Applies the modifier’s logic to the given content component.
    ///
    /// - Parameter content: The content component to modify.
    /// - Returns: The modified content component.
    @discardableResult
    func body(_ content: Self.Content) -> Self.Content
}
