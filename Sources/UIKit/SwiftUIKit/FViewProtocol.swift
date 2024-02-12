//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore

public protocol AnyViewable: AnyObject {
    func rendered() -> UIView
}

public protocol FViewable: AnyViewable, Chainable {
    associatedtype SomeView: UIView
    var customConfiguration: ((SomeView, Self) -> SomeView)? { get set }
    var backgroundColor: UIColor? { get set }
    var padding: UIEdgeInsets? { get set }
    var content: SomeView? { get }
    
    @discardableResult
    func rendered() -> SomeView
    func padding(_ padding: UIEdgeInsets) -> Self
    func background(_ color: UIColor) -> Self
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
}

public extension FViewable {
    func rendered() -> UIView {
        rendered()
    }
    
    func callAsFunction() -> UIView {
        rendered()
    }
}
