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
    func rendered() -> SomeView
}

public extension FViewable {
    func rendered() -> UIView {
        rendered()
    }
    
    func callAsFunction() -> UIView {
        rendered()
    }
}
