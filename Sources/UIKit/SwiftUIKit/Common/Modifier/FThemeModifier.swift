//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 2/10/24.
//

import UIKit

public struct FBackgroundModifier: FModifier {
    public var key: ThemeKey?
    public var color: UIColor?
    
    public init(key: ThemeKey? = nil, color: UIColor? = nil) {
        self.key = key
        self.color = color
    }
    
    public func body(_ content: Content) -> Content {
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

public struct FForegroundModifier: FModifier {
    public var key: ThemeKey?
    public var color: UIColor?

    public init(key: ThemeKey? = nil, color: UIColor? = nil) {
        self.key = key
        self.color = color
    }
    
    public func body(_ content: Content) -> Content {
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
