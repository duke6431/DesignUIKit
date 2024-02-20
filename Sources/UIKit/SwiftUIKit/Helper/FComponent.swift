//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore
import DesignExts

public protocol FComponent: FContaining {
    associatedtype SomeView: UIView
    var customConfiguration: ((SomeView, Self) -> SomeView)? { get set }
    var content: SomeView? { get }
    
    @discardableResult
    func rendered() -> SomeView
}

public extension FComponent {
    func customConfiguration(_ configuration: ((SomeView, Self) -> SomeView)?) -> Self {
        with(\.customConfiguration, setTo: configuration)
    }
}

public enum FShape {
    case circle
    case roundedRectangle(cornerRadius: CGFloat, corners: UIRectCorner = .allCorners)
}

public protocol FTappable: AnyObject, Chainable {
    var onTap: (() -> Void)? { get set }
    func onTap(_ gesture: @escaping () -> Void) -> Self
}
