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
    @discardableResult func customConfiguration(_ configuration: ((Self) -> Void)?) -> Self {
        with(\.customConfiguration, setTo: configuration)
    }
}

public protocol FContentConstraintable: AnyObject {
    @discardableResult
    func huggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self
    @discardableResult
    func compressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self
}

public extension FContentConstraintable where Self: UIView {
    @discardableResult func huggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        setContentHuggingPriority(priority, for: axis)
        return self
    }

    @discardableResult func compressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        setContentCompressionResistancePriority(priority, for: axis)
        return self
    }
}

public protocol FContentAvailable: FContentConstraintable {
    @discardableResult func insets(_ insets: UIEdgeInsets) -> Self
    @discardableResult func insets(_ insets: CGFloat) -> Self
    @discardableResult func insets(_ edges: UIRectEdge, _ insets: CGFloat) -> Self
}

public extension FContentAvailable where Self: BaseLabel {
    @discardableResult func insets(_ insets: UIEdgeInsets) -> Self {
        contentInsets = contentInsets + insets
        return self
    }

    @discardableResult func insets(_ insets: CGFloat) -> Self {
        self.insets(.all, insets)
    }

    @discardableResult func insets(_ edges: UIRectEdge, _ insets: CGFloat) -> Self {
        contentInsets = contentInsets.add(edges, insets)
        return self
    }
}

public enum FShape {
    case circle
    case roundedRectangle(cornerRadius: CGFloat, corners: UIRectCorner = .allCorners)
}
