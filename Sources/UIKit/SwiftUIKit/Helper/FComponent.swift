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

public protocol FContentContaining {
    var contentHuggingV: UILayoutPriority { get set }
    var contentHuggingH: UILayoutPriority { get set }
    var compressionResistanceV: UILayoutPriority { get set }
    var compressionResistanceH: UILayoutPriority { get set }
}

public extension FContentContaining {
    func huggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        switch axis {
        case .horizontal:
            contentHuggingH = priority
        case .vertical:
            contentHuggingV = priority
        @unknown default:
            break
        }
        return self
    }
    
    func compressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        switch axis {
        case .horizontal:
            compressionResistanceH = priority
        case .vertical:
            compressionResistanceV = priority
        @unknown default:
            break
        }
        return self
    }
}

public protocol FStylable {
    var font: UIFont { get set }
    var color: UIColor { get set }
}

public extension FStylable {
    func font(_ font: UIFont = FontSystem.shared.font(with: .body)) -> Self {
        with(\.font, setTo: font)
    }

    func foreground(_ color: UIColor = .label) -> Self {
        with(\.color, setTo: color)
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
