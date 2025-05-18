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
    /// Applies a transformation to the given `FBodyComponent`.
    ///
    /// - Parameter content: The original body component to be modified.
    /// - Returns: A new `FBodyComponent` after applying the transformation.
    @discardableResult
    func body(_ content: FBodyComponent) -> FBodyComponent
}
