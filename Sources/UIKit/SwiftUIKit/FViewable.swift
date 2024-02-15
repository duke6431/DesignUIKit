//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore
import DesignExts

public protocol FViewable: AnyObject, Chainable {
    associatedtype SomeView: UIView
    var shadow: CALayer.ShadowConfiguration? { get set }
    var shape: FShape? { get set }
    var contentBackgroundColor: UIColor { get set }
    var containerPadding: UIEdgeInsets? { get set }
    var contentInsets: UIEdgeInsets? { get set }
    
    var customConfiguration: ((SomeView, Self) -> SomeView)? { get set }
    var content: SomeView? { get }
    
    var shouldConstraintWithParent: Bool { get set }
    
    @discardableResult
    func rendered() -> SomeView
    func padding() -> Self
    func padding(_ padding: CGFloat) -> Self
    func padding(_ edges: UIRectEdge, _ padding: CGFloat) -> Self
    func insets(_ insets: CGFloat) -> Self
    func insets(_ edges: UIRectEdge, _ insets: CGFloat) -> Self
    func background(_ color: UIColor) -> Self
    func shaped(_ shape: FShape) -> Self
    func shadow(_ shadow: CALayer.ShadowConfiguration) -> Self
}

public enum FShape {
    case circle
    case roundedRectangle(cornerRadius: CGFloat, corners: UIRectCorner = .allCorners)
}
