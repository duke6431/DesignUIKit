//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore
import DesignExts

public protocol FComponent: AnyObject, Chainable {
    var configuration: FConfiguration? { get }
    var customConfiguration: ((Self) -> Void)? { get set }
}

public extension FComponent {
    func customConfiguration(_ configuration: ((Self) -> Void)?) -> Self {
        with(\.customConfiguration, setTo: configuration)
    }
}

public protocol FContentConstraintable: AnyObject {
    func huggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self
    func compressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self
}

public extension FContentConstraintable where Self: UIView {
    func huggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        setContentHuggingPriority(priority, for: axis)
        return self
    }
    
    func compressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        setContentCompressionResistancePriority(priority, for: axis)
        return self
    }
}

public protocol FContentAvailable: FContentConstraintable {
    func insets(_ insets: UIEdgeInsets) -> Self
    func insets(_ insets: CGFloat) -> Self
    func insets(_ edges: UIRectEdge, _ insets: CGFloat) -> Self
}

public extension FContentAvailable where Self: BaseLabel {
    func insets(_ insets: UIEdgeInsets) -> Self {
        contentInsets = contentInsets + insets
        return self
    }
    
    func insets(_ insets: CGFloat) -> Self {
        self.insets(.all, insets)
    }
    
    func insets(_ edges: UIRectEdge, _ insets: CGFloat) -> Self {
        contentInsets = contentInsets.add(edges, insets)
        return self
    }
}

public protocol FStylable: AnyObject, Chainable {
    func font(_ font: UIFont) -> Self
    func foreground(_ color: UIColor) -> Self
}

public extension FStylable where Self: UILabel {
    func font(_ font: UIFont = FontSystem.shared.font(with: .body)) -> Self {
        with(\.font, setTo: font)
    }

    func foreground(_ color: UIColor = .label) -> Self {
        with(\.textColor, setTo: color)
    }
}

public extension FStylable where Self: UIButton {
    func font(_ font: UIFont = FontSystem.shared.font(with: .body)) -> Self {
        titleLabel?.with(\.font, setTo: font)
        return self
    }

    func foreground(_ color: UIColor = .label) -> Self {
        setTitleColor(color, for: .normal)
        return self
    }
}

public enum FShape {
    case circle
    case roundedRectangle(cornerRadius: CGFloat, corners: UIRectCorner = .allCorners)
}
