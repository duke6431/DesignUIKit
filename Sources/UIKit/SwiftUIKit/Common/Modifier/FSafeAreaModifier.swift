//
//  FSafeAreaModifier.swift
//  ComponentSystem
//
//  Created by Duke Nguyen on 2024/10/14.
//
//  A modifier that controls whether a component should ignore safe area insets.
//

import Foundation

/// A modifier that determines whether the content should ignore the safe area insets.
/// Useful for creating edge-to-edge layouts.
public struct FSafeAreaModifier: FModifier {
    /// Indicates whether the safe area should be ignored.
    var isIgnore: Bool
    
    /// Initializes the modifier with a boolean flag to ignore or respect the safe area.
    /// - Parameter isIgnore: A boolean indicating if the safe area should be ignored.
    public init(_ isIgnore: Bool) {
        self.isIgnore = isIgnore
    }
    
    /// Applies the safe area ignore setting to the given content.
    /// - Parameter content: The content component to modify.
    /// - Returns: The modified content with or without safe area insets.
    public func body(_ content: FBodyComponent) -> FBodyComponent {
        content.ignoreSafeArea(isIgnore)
    }
}
