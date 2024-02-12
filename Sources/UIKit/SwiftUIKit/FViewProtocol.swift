//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore

public enum FShape {
    case circle
    case roundedRectangle(cornerRadius: CGFloat, corners: UIRectCorner = .allCorners)
}

extension UIRectCorner {
    var caMask: CACornerMask {
        switch self {
        case .topLeft:
            return .layerMinXMinYCorner
        case .topRight:
            return .layerMaxXMinYCorner
        case .bottomLeft:
            return .layerMinXMaxYCorner
        case .bottomRight:
            return .layerMaxXMaxYCorner
        default:
            return [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
}

public protocol AnyViewable: AnyObject {
    func rendered() -> UIView
}

public protocol FViewable: AnyViewable, Chainable {
    associatedtype SomeView: UIView
    var shape: FShape? { get set }
    var backgroundColor: UIColor? { get set }
    var padding: UIEdgeInsets? { get set }
    
    var customConfiguration: ((SomeView, Self) -> SomeView)? { get set }
    var content: SomeView? { get }
    
    @discardableResult
    func rendered() -> SomeView
    func padding(_ padding: UIEdgeInsets) -> Self
    func background(_ color: UIColor) -> Self
    func shaped(_ shape: FShape) -> Self
}

public extension FViewable {
    func padding(_ padding: UIEdgeInsets) -> Self {
        self.padding = padding
        return self
    }
    func background(_ color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
    func shaped(_ shape: FShape) -> Self {
        self.shape = shape
        return self
    }
}

public extension FViewable {
    func rendered() -> UIView {
        rendered()
    }
    
    func callAsFunction() -> UIView {
        rendered()
    }
}
