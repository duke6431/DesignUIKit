//
//  FThemeModifier.swift
//  ComponentSystem
//
//  Created by Duke Nguyen on 2024/02/10.
//
//  Modifiers for applying theme-based background and foreground colors
//  to components that support theming.
//

import UIKit

/// A modifier that applies a background color or theme key to a component supporting background theming.
public struct FBackgroundModifier: FModifier {
    /// A theme key used to fetch a background color from the theme.
    public var key: ThemeKey?
    /// A static `UIColor` to be applied as the background.
    public var color: UIColor?
    
    /// Creates a new background modifier with an optional theme key or static color.
    /// - Parameters:
    ///   - key: A theme key to fetch the color.
    ///   - color: A static `UIColor` value.
    public init(key: ThemeKey? = nil, color: UIColor? = nil) {
        self.key = key
        self.color = color
    }
    
    /// Applies the background color or theme key to the content if it supports theming.
    /// - Parameter content: The content to modify.
    /// - Returns: The modified content or the original if unsupported.
    public func body(_ content: FBodyComponent) -> FBodyComponent {
        guard let modifiedContent = content as? (FBodyComponent & FThemableBackground) else { return content }
        if let key {
            return modifiedContent.background(key: key)
        } else if let color {
            return content.background(color)
        } else {
            return content
        }
    }
}

/// A modifier that applies a foreground color or theme key to a component supporting foreground theming.
public struct FForegroundModifier: FModifier {
    /// A theme key used to fetch a background color from the theme.
    public var key: ThemeKey?
    /// A static `UIColor` to be applied as the background.
    public var color: UIColor?
    
    /// Creates a new background modifier with an optional theme key or static color.
    /// - Parameters:
    ///   - key: A theme key to fetch the color.
    ///   - color: A static `UIColor` value.
    public init(key: ThemeKey? = nil, color: UIColor? = nil) {
        self.key = key
        self.color = color
    }
    
    /// Applies the foreground color or theme key to the content if it supports theming.
    /// - Parameter content: The content to modify.
    /// - Returns: The modified content or the original if unsupported.
    public func body(_ content: FBodyComponent) -> FBodyComponent {
        guard let modifiedContent = content as? (FBodyComponent & FThemableForeground) else { return content }
        if let key {
            return modifiedContent.foreground(key: key)
        } else if let color {
            return modifiedContent.foreground(color)
        } else {
            return content
        }
    }
}
