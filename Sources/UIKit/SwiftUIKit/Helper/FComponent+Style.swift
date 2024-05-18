//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 4/5/24.
//

import QuartzCore
import DesignCore
import DesignExts
import Foundation

@objc public protocol FStylable: AnyObject, Chainable {
    @discardableResult @objc optional func font(_ font: BFont) -> Self
    @discardableResult func foreground(_ color: BColor) -> Self
}

public protocol FThemableForeground: Themable {
    var foregroundKey: ThemeKey? { get set }
    @discardableResult func foreground(key: ThemeKey) -> Self
}

public protocol FThemablePlaceholder: Themable {
    var placeholderKey: ThemeKey? { get set }
    @discardableResult func placeholder(key: ThemeKey) -> Self
}

public protocol FThemableBackground: Themable {
    var backgroundKey: ThemeKey? { get set }
    @discardableResult func background(key: ThemeKey) -> Self
}

public protocol FThemableShadow: Themable {
    var shadowKey: ThemeKey? { get set }
    @discardableResult func shadow(key: ThemeKey) -> Self
    @discardableResult func shadow(_ shadow: CALayer.ShadowConfiguration) -> Self
    @discardableResult func shadow(_ shadow: CALayer.ShadowConfiguration, key: ThemeKey) -> Self
}

extension FThemableBackground {
    @discardableResult
    public func background(key: ThemeKey) -> Self {
        backgroundKey = key
        ThemeSystem.shared.register(observer: self)
        return self
    }
}

extension FThemablePlaceholder {
    @discardableResult
    public func placeholder(key: ThemeKey) -> Self {
        placeholderKey = key
        ThemeSystem.shared.register(observer: self)
        return self
    }
}

extension FThemableForeground {
    @discardableResult
    public func foreground(key: ThemeKey) -> Self {
        foregroundKey = key
        ThemeSystem.shared.register(observer: self)
        return self
    }
}

extension FThemableShadow {
    @discardableResult
    public func shadow(key: ThemeKey) -> Self {
        shadowKey = key
        ThemeSystem.shared.register(observer: self)
        return self
    }
    
    @discardableResult
    public func shadow(_ shadow: CALayer.ShadowConfiguration, key: ThemeKey) -> Self {
        self.shadow(shadow).shadow(key: key)
    }
}
