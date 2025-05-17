//
//  FComponent+Style.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2024/04/05.
//
//  This file contains style-related protocols and extensions for FComponent,
//  enabling theming and styling capabilities such as fonts, colors, backgrounds,
//  placeholders, and shadows.
//

import UIKit
import QuartzCore
import DesignCore
import DesignExts
import Foundation

/// A protocol that defines the capability to apply a font style to a component.
/// Conforms to `Chainable` for fluent interface usage.
public protocol FCalligraphiable: AnyObject, Chainable {
    /// Sets the font of the component.
    /// - Parameter font: The `UIFont` to apply.
    /// - Returns: Self, to allow chaining.
    @discardableResult func font(_ font: UIFont) -> Self
}

/// A protocol that defines theming capabilities for foreground colors.
/// Conforms to `Themable`.
public protocol FThemableForeground: Themable {
    /// The theme key associated with the foreground color.
    var foregroundKey: ThemeKey? { get set }
    
    /// Sets the foreground color directly.
    /// - Parameter color: The `UIColor` to apply.
    /// - Returns: Self, to allow chaining.
    @discardableResult func foreground(_ color: UIColor) -> Self
    
    /// Sets the foreground color using a theme key.
    /// - Parameter key: The `ThemeKey` to apply.
    /// - Returns: Self, to allow chaining.
    @discardableResult func foreground(key: ThemeKey) -> Self
}

/// A protocol that defines theming capabilities for placeholder text.
/// Conforms to `Themable`.
public protocol FThemablePlaceholder: Themable {
    /// The theme key associated with the placeholder.
    var placeholderKey: ThemeKey? { get set }
    
    /// Sets the placeholder text color using a theme key.
    /// - Parameter key: The `ThemeKey` to apply.
    /// - Returns: Self, to allow chaining.
    @discardableResult func placeholder(key: ThemeKey) -> Self
}

/// A protocol that defines theming capabilities for background colors.
/// Conforms to `Themable`.
public protocol FThemableBackground: Themable {
    /// The theme key associated with the background color.
    var backgroundKey: ThemeKey? { get set }
    
    /// Sets the background color using a theme key.
    /// - Parameter key: The `ThemeKey` to apply.
    /// - Returns: Self, to allow chaining.
    @discardableResult func background(key: ThemeKey) -> Self
}

/// A protocol that defines theming capabilities for shadows.
/// Conforms to `Themable`.
public protocol FThemableShadow: Themable {
    /// The theme key associated with the shadow.
    var shadowKey: ThemeKey? { get set }
    
    /// Sets the shadow configuration directly.
    /// - Parameter shadow: The `CALayer.ShadowConfiguration` to apply.
    /// - Returns: Self, to allow chaining.
    @discardableResult func shadow(_ shadow: CALayer.ShadowConfiguration) -> Self
    
    /// Sets the shadow configuration with an associated theme key.
    /// - Parameters:
    ///   - shadow: The `CALayer.ShadowConfiguration` to apply.
    ///   - key: The `ThemeKey` to apply.
    /// - Returns: Self, to allow chaining.
    @discardableResult func shadow(_ shadow: CALayer.ShadowConfiguration, key: ThemeKey) -> Self
    
    /// Sets the shadow using a theme key.
    /// - Parameter key: The `ThemeKey` to apply.
    /// - Returns: Self, to allow chaining.
    @discardableResult func shadow(key: ThemeKey) -> Self
}

extension FThemableBackground {
    /// Sets the background color using a theme key and registers the component as a theme observer.
    /// - Parameter key: The `ThemeKey` to apply.
    /// - Returns: Self, to allow chaining.
    @discardableResult
    public func background(key: ThemeKey) -> Self {
        backgroundKey = key
        ThemeSystem.shared.register(observer: self)
        return self
    }
}

extension FThemablePlaceholder {
    /// Sets the placeholder text color using a theme key and registers the component as a theme observer.
    /// - Parameter key: The `ThemeKey` to apply.
    /// - Returns: Self, to allow chaining.
    @discardableResult
    public func placeholder(key: ThemeKey) -> Self {
        placeholderKey = key
        ThemeSystem.shared.register(observer: self)
        return self
    }
}

extension FThemableForeground {
    /// Sets the foreground color using a theme key and registers the component as a theme observer.
    /// - Parameter key: The `ThemeKey` to apply.
    /// - Returns: Self, to allow chaining.
    @discardableResult
    public func foreground(key: ThemeKey) -> Self {
        foregroundKey = key
        ThemeSystem.shared.register(observer: self)
        return self
    }
}

extension FThemableShadow {
    /// Sets the shadow using a theme key and registers the component as a theme observer.
    /// - Parameter key: The `ThemeKey` to apply.
    /// - Returns: Self, to allow chaining.
    @discardableResult
    public func shadow(key: ThemeKey) -> Self {
        shadowKey = key
        ThemeSystem.shared.register(observer: self)
        return self
    }
    
    /// Sets the shadow configuration and associates it with a theme key.
    /// - Parameters:
    ///   - shadow: The `CALayer.ShadowConfiguration` to apply.
    ///   - key: The `ThemeKey` to apply.
    /// - Returns: Self, to allow chaining.
    @discardableResult
    public func shadow(_ shadow: CALayer.ShadowConfiguration, key: ThemeKey) -> Self {
        self.shadow(shadow).shadow(key: key)
    }
}
