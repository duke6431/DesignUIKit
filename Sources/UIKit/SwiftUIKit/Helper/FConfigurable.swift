//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 2/20/24.
//

import UIKit
import DesignCore
import DesignExts
import SnapKit
import Combine

public protocol FConfigurable: AnyObject, Chainable {
    var configuration: FConfiguration? { get }
    
    @discardableResult func frame(height: CGFloat) -> Self
    @discardableResult func frame(width: CGFloat) -> Self
    @discardableResult func frame(width: CGFloat, height: CGFloat) -> Self
    @discardableResult func ratio(_ ratio: CGFloat) -> Self
    @discardableResult func padding() -> Self
    @discardableResult func padding(_ padding: CGFloat) -> Self
    @discardableResult func padding(_ edges: NSDirectionalRectEdge, _ padding: CGFloat) -> Self
    @discardableResult func offset(_ size: CGSize) -> Self
    @discardableResult func offset(width: CGFloat, height: CGFloat) -> Self
    @discardableResult func background(_ color: UIColor) -> Self
    @discardableResult func shaped(_ shape: FShape) -> Self
    @discardableResult func shadow(_ shadow: CALayer.ShadowConfiguration) -> Self
    @discardableResult func attachToParent(_ status: Bool) -> Self
    @discardableResult func opacity(_ opacity: CGFloat) -> Self
}

public class FConfiguration: Chainable {
    public var width: CGFloat?
    public var height: CGFloat?
    public var offset: CGSize = .zero
    public var shadow: CALayer.ShadowConfiguration?
    public var shape: FShape?
    public var backgroundColor: UIColor = .clear
    public var containerPadding: NSDirectionalEdgeInsets?
    public var ratio: CGFloat?
    public var opacity: CGFloat = 1

    public var shouldConstraintWithParent: Bool = true
    public weak var owner: UIView?
    
    public func didMoveToSuperview(_ superview: UIView?, with target: UIView) {
        target.backgroundColor = backgroundColor
        target.alpha = opacity
        if shouldConstraintWithParent, superview != nil {
            target.snp.remakeConstraints {
                $0.top.equalToSuperview().offset(offset.height + (containerPadding?.top ?? 0))
                $0.leading.equalToSuperview().offset(offset.width + (containerPadding?.leading ?? 0))
                $0.trailing.equalToSuperview().offset(offset.width - (containerPadding?.trailing ?? 0))
                $0.bottom.equalToSuperview().offset(offset.height - (containerPadding?.bottom ?? 0))
            }
        }
        target.snp.makeConstraints {
            if let width, width > 0 { $0.width.equalTo(width) }
            if let height, height > 0 { $0.height.equalTo(height) }
            if let ratio { $0.width.equalTo(target.snp.height).multipliedBy(ratio) }
        }
    }
    
    public func updateLayers(for target: UIView) {
        if let shape {
            target.clipsToBounds = true
            UIView.animate(withDuration: 0.2) {
                switch shape {
                case .circle:
                    target.layer.cornerRadius = min(target.bounds.width, target.bounds.height) / 2
                case .roundedRectangle(let cornerRadius, let corners):
                    target.layer.maskedCorners = corners.caMask
                    target.layer.cornerRadius = min(cornerRadius, min(target.bounds.width, target.bounds.height) / 2)
                }
            }
        }
        if let shadow {
            UIView.animate(withDuration: 0.2) {
                target.layer.add(
                    shadow: shadow.updated(
                        \.path, with: UIBezierPath(rect: target.bounds).cgPath
                    )
                )
            }
        }
    }
}
