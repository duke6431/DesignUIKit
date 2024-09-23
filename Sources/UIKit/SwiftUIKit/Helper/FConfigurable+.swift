//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 15/02/2024.
//

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif
import DesignExts
import DesignCore
import SnapKit

public extension FConfigurable {
    @discardableResult func offset(_ size: CGSize) -> Self {
        offset(width: size.width, height: size.height)
    }
    
    @discardableResult func offset(width: CGFloat, height: CGFloat) -> Self {
        configuration?.offset = .init(
            width: width + (configuration?.offset.width ?? 0),
            height: height + (configuration?.offset.height ?? 0)
        )
        return self
    }
    
    @discardableResult func padding() -> Self {
        self.padding(8)
    }
    
    @discardableResult func padding(_ insets: NSDirectionalEdgeInsets) -> Self {
        configuration?.containerPadding = (configuration?.containerPadding ?? .zero) + insets
        return self
    }
    
    @discardableResult func padding(_ padding: CGFloat) -> Self {
        self.padding(.all, padding)
    }
    
    @discardableResult func padding(_ edges: NSDirectionalRectEdge, _ padding: CGFloat) -> Self {
        configuration?.containerPadding = (configuration?.containerPadding ?? .zero).add(edges, padding)
        return self
    }
    
    @discardableResult func padding(with style: SpacingSystem.CommonSpacing) -> Self {
        padding(SpacingSystem.shared.spacing(style))
    }
    @discardableResult func padding(_ edges: NSDirectionalRectEdge, with style: SpacingSystem.CommonSpacing) -> Self {
        padding(edges, SpacingSystem.shared.spacing(style))
    }
    
    @discardableResult func background(_ color: UIColor) -> Self {
        configuration?.with(\.backgroundColor, setTo: color)
        return self
    }
    
    @discardableResult func shaped(_ shape: FShape) -> Self {
        configuration?.with(\.shape, setTo: shape)
        return self
    }
    
    @discardableResult func shadow(_ shadow: CALayer.ShadowConfiguration) -> Self {
        configuration?.with(\.shadow, setTo: shadow)
        return self
    }
    
    @discardableResult func opacity(_ opacity: CGFloat) -> Self {
        configuration?.with(\.opacity, setTo: opacity)
        return self
    }
    
    @discardableResult func ratio(_ ratio: CGFloat) -> Self {
        configuration?.with(\.ratio, setTo: ratio)
        return self
    }
    
    @discardableResult func ignoreSafeArea(_ status: Bool) -> Self {
        configuration?.with(\.shouldIgnoreSafeArea, setTo: status)
        return self
    }
    
    @discardableResult func attachToParent(_ status: Bool) -> Self {
        configuration?.with(\.shouldConstraintWithParent, setTo: status)
        return self
    }
    
    @discardableResult func frame(height: CGFloat) -> Self {
        configuration?.with(\.height, setTo: height)
        return self
    }
    
    @discardableResult func frame(width: CGFloat) -> Self {
        configuration?.with(\.width, setTo: width)
        return self
    }
    
    @discardableResult func frame(width: CGFloat, height: CGFloat) -> Self {
        configuration?.with(\.height, setTo: height).with(\.width, setTo: width)
        return self
    }
    
    @discardableResult func centerInParent() -> Self {
        centerInParent(offset: .zero)
    }

    @discardableResult func centerInParent(offset: CGSize) -> Self {
        configuration?.with(\.centerOffset, setTo: offset)
        return self
    }
    
    @discardableResult func layout(_ layoutConfiguration: @escaping (_ make: ConstraintMaker, _ superview: BView) -> Void) -> Self {
        configuration?.with(\.layoutConfiguration, setTo: layoutConfiguration)
        return self
    }
    
    @discardableResult func layer(_ layerConfiguration: @escaping (UIView) -> Void) -> Self {
        configuration?.with(\.layerConfiguration, setTo: layerConfiguration)
        return self
    }
}
