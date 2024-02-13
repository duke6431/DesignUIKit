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

public protocol FViewable: AnyObject, Chainable {
    associatedtype SomeView: UIView
    var shape: FShape? { get set }
    var backgroundColor: UIColor? { get set }
    var padding: UIEdgeInsets? { get set }
    
    var customConfiguration: ((SomeView, Self) -> SomeView)? { get set }
    var content: SomeView? { get }
    
    @discardableResult
    func rendered() -> SomeView
    func padding(_ padding: CGFloat) -> Self
    func padding(_ edges: UIRectEdge, _ padding: CGFloat) -> Self
    func background(_ color: UIColor) -> Self
    func shaped(_ shape: FShape) -> Self
}

public extension FViewable {
    func padding(_ padding: CGFloat) -> Self {
        self.padding(.all, padding)
    }
    
    func padding(_ edges: UIRectEdge, _ padding: CGFloat) -> Self {
        self.padding = self.padding?.add(edges, padding)
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
