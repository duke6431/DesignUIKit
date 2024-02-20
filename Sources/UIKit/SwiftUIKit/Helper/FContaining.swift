//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 2/20/24.
//

import UIKit
import DesignCore
import DesignExts

public protocol FContaining: AnyObject, Chainable {
    var shadow: CALayer.ShadowConfiguration? { get set }
    var shape: FShape? { get set }
    var contentBackgroundColor: UIColor { get set }
    var containerPadding: UIEdgeInsets? { get set }
    var contentInsets: UIEdgeInsets? { get set }
    
    var shouldConstraintWithParent: Bool { get set }
    
    func padding() -> Self
    func padding(_ padding: CGFloat) -> Self
    func padding(_ edges: UIRectEdge, _ padding: CGFloat) -> Self
    func insets(_ insets: CGFloat) -> Self
    func insets(_ edges: UIRectEdge, _ insets: CGFloat) -> Self
    func background(_ color: UIColor) -> Self
    func shaped(_ shape: FShape) -> Self
    func shadow(_ shadow: CALayer.ShadowConfiguration) -> Self
}
