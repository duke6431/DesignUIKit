//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 15/02/2024.
//

import UIKit
import DesignExts
import DesignCore

public extension FContaining {
    func padding() -> Self {
        self.padding(8)
    }
    
    func padding(_ insets: UIEdgeInsets) -> Self {
        self.containerPadding = (containerPadding ?? .zero) + insets
        return self
    }
    
    func padding(_ padding: CGFloat) -> Self {
        self.padding(.all, padding)
    }
    
    func padding(_ edges: UIRectEdge, _ padding: CGFloat) -> Self {
        self.containerPadding = (self.containerPadding ?? .zero).add(edges, padding)
        return self
    }
    
    func insets(_ insets: UIEdgeInsets) -> Self {
        self.contentInsets = (contentInsets ?? .zero) + insets
        return self
    }
    
    func insets(_ insets: CGFloat) -> Self {
        self.insets(.all, insets)
    }
    
    func insets(_ edges: UIRectEdge, _ insets: CGFloat) -> Self {
        self.contentInsets = (self.contentInsets ?? .zero).add(edges, insets)
        return self
    }
    
    func background(_ color: UIColor) -> Self {
        with(\.contentBackgroundColor, setTo: color)
    }
    
    func shaped(_ shape: FShape) -> Self {
        with(\.shape, setTo: shape)
    }
    
    func shadow(_ shadow: CALayer.ShadowConfiguration) -> Self {
        with(\.shadow, setTo: shadow)
    }
    
    func opacity(_ opacity: CGFloat) -> Self {
        with(\.opacity, setTo: opacity)
    }
    
    func ratio(_ ratio: CGFloat) -> Self {
        with(\.ratio, setTo: ratio)
    }
}

public extension FTappable {
    func onTap(_ gesture: @escaping () -> Void) -> Self {
        with(\.onTap, setTo: gesture)
    }
}
