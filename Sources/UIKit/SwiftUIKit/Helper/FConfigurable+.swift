//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 15/02/2024.
//

import UIKit
import DesignExts
import DesignCore

public extension FConfigurable {
    func offset(x: CGFloat, y: CGFloat) -> Self {
        configuration?.offset = .init(
            x: x + (configuration?.offset.x ?? 0),
            y: y + (configuration?.offset.y ?? 0)
        )
        return self
    }
    
    func padding() -> Self {
        self.padding(8)
    }
    
    func padding(_ insets: NSDirectionalEdgeInsets) -> Self {
        configuration?.containerPadding = (configuration?.containerPadding ?? .zero) + insets
        return self
    }
    
    func padding(_ padding: CGFloat) -> Self {
        self.padding(.all, padding)
    }
    
    func padding(_ edges: NSDirectionalRectEdge, _ padding: CGFloat) -> Self {
        configuration?.containerPadding = (configuration?.containerPadding ?? .zero).add(edges, padding)
        return self
    }
    
    func background(_ color: UIColor) -> Self {
        configuration?.with(\.backgroundColor, setTo: color)
        return self
    }
    
    func shaped(_ shape: FShape) -> Self {
        configuration?.with(\.shape, setTo: shape)
        return self
    }
    
    func shadow(_ shadow: CALayer.ShadowConfiguration) -> Self {
        configuration?.with(\.shadow, setTo: shadow)
        return self
    }
    
    func opacity(_ opacity: CGFloat) -> Self {
        configuration?.with(\.opacity, setTo: opacity)
        return self
    }
    
    func ratio(_ ratio: CGFloat) -> Self {
        configuration?.with(\.ratio, setTo: ratio)
        return self
    }
    
    func attachToParent(_ status: Bool) -> Self {
        configuration?.with(\.shouldConstraintWithParent, setTo: status)
        return self
    }
    
    func frame(height: CGFloat) -> Self {
        configuration?.with(\.height, setTo: height)
        return self
    }
    
    func frame(width: CGFloat) -> Self {
        configuration?.with(\.width, setTo: width)
        return self
    }
    
    func frame(width: CGFloat, height: CGFloat) -> Self {
        configuration?.with(\.height, setTo: height).with(\.width, setTo: width)
        return self
    }
}
