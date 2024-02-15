//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 15/02/2024.
//

import UIKit
import DesignExts

public extension FViewable {
    func padding() -> Self {
        self.padding(8)
    }
    
    func padding(_ padding: CGFloat) -> Self {
        self.padding(.all, padding)
    }
    
    func padding(_ edges: UIRectEdge, _ padding: CGFloat) -> Self {
        self.containerPadding = (self.containerPadding ?? .zero).add(edges, padding)
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
        self.contentBackgroundColor = color
        return self
    }
    
    func shaped(_ shape: FShape) -> Self {
        self.shape = shape
        return self
    }
    
    func shadow(_ shadow: CALayer.ShadowConfiguration) -> Self {
        self.shadow = shadow
        return self
    }
}
