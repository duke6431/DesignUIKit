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

public protocol FConfigurable: AnyObject, Chainable {
    var configuration: FConfiguration? { get }

    @discardableResult func frame(height: CGFloat) -> Self
    @discardableResult func frame(width: CGFloat) -> Self
    @discardableResult func frame(width: CGFloat, height: CGFloat) -> Self
    @discardableResult func layoutPriority(_ priority: ConstraintPriority) -> Self
    @discardableResult func centerInParent() -> Self
    @discardableResult func centerInParent(offset: CGSize) -> Self
    @discardableResult func ratio(_ ratio: CGFloat) -> Self
    @discardableResult func padding() -> Self
    @discardableResult func padding(_ padding: CGFloat) -> Self
    @discardableResult func padding(_ edges: NSDirectionalRectEdge, _ padding: CGFloat) -> Self
    @discardableResult func padding(with style: SpacingSystem.CommonSpacing) -> Self
    @discardableResult func padding(_ edges: NSDirectionalRectEdge, with style: SpacingSystem.CommonSpacing) -> Self
    @discardableResult func offset(_ size: CGSize) -> Self
    @discardableResult func offset(width: CGFloat, height: CGFloat) -> Self
    @discardableResult func background(_ color: UIColor) -> Self
    @discardableResult func shaped(_ shape: FShape) -> Self
    @discardableResult func shadow(_ shadow: CALayer.ShadowConfiguration) -> Self
    @discardableResult func ignoreSafeArea(_ status: Bool) -> Self
    @discardableResult func attachToParent(_ status: Bool) -> Self
    @discardableResult func opacity(_ opacity: CGFloat) -> Self
    @discardableResult func layout(_ layoutConfiguration: @escaping (_ make: ConstraintMaker, _ superview: UIView) -> Void) -> Self
    @discardableResult func layer(_ layerConfiguration: @escaping (UIView) -> Void) -> Self
    @discardableResult func modified(with modifier: FModifier) -> Self
    @discardableResult func clearModifiers() -> Self
}

public class FConfiguration: Chainable {
    var modifiers: [FModifier] = []
    var clearModifiers: Bool = false
    
    public var width: CGFloat?
    public var height: CGFloat?
    public var offset: CGSize = .zero
    public var shadow: CALayer.ShadowConfiguration?
    public var shape: FShape?
    public var backgroundColor: UIColor = .clear
    public var containerPadding: NSDirectionalEdgeInsets?
    public var ratio: CGFloat?
    public var opacity: CGFloat = 1
    public var centerOffset: CGSize?
    public var layoutPriority: ConstraintPriority = .high.advanced(by: 100)
    public var layoutConfiguration: ((_ make: ConstraintMaker, _ superview: UIView) -> Void)?
    public var layerConfiguration: ((UIView) -> Void)?
    
    public var shouldIgnoreSafeArea: Bool = false
    public var shouldConstraintWithParent: Bool = true
    public weak var owner: UIView?

    func willMove(toSuperview newSuperview: UIView?) {
        guard let newSuperview = newSuperview as? FBodyComponent else { return }
        if !clearModifiers {
            modifiers = (newSuperview.configuration?.modifiers ?? []) + modifiers
        }
    }
    
    public func didMoveToSuperview(_ superview: UIView?, with target: FBodyComponent) {
        modifiers.forEach { $0.body(target) }
        target.backgroundColor = backgroundColor
        target.alpha = opacity
        if let centerOffset, let superview {
            target.snp.makeConstraints {
                $0.centerX.equalTo(superview.safeAreaLayoutGuide).offset(centerOffset.width).priority(layoutPriority)
                $0.centerY.equalTo(superview.safeAreaLayoutGuide).offset(centerOffset.height).priority(layoutPriority)
            }
        } else if shouldConstraintWithParent, let superview {
            target.snp.remakeConstraints {
                let target: ConstraintRelatableTarget = shouldIgnoreSafeArea ? superview : superview.safeAreaLayoutGuide
                $0.top.equalTo(target).offset(offset.height + (containerPadding?.top ?? 0)).priority(layoutPriority)
                $0.leading.equalTo(target).offset(offset.width + (containerPadding?.leading ?? 0)).priority(layoutPriority)
                $0.trailing.equalTo(target).offset(offset.width - (containerPadding?.trailing ?? 0)).priority(layoutPriority)
                $0.bottom.equalTo(target).offset(offset.height - (containerPadding?.bottom ?? 0)).priority(layoutPriority)
            }
        }
        target.snp.makeConstraints {
            if let width, width > 0 { $0.width.equalTo(width).priority(layoutPriority) }
            if let height, height > 0 { $0.height.equalTo(height).priority(layoutPriority) }
            if let ratio { $0.width.equalTo(target.snp.height).multipliedBy(ratio).priority(layoutPriority) }
        }
        if let layoutConfiguration, let superview {
            target.snp.makeConstraints {
                layoutConfiguration($0, superview)
            }
        }
    }
    
    public func updateLayers(for target: UIView) {
        var shadowCornerRadius: CGFloat = 0
        var shadowCorners: UIRectCorner = .allCorners
        if let shape {
            target.clipsToBounds = true
            UIView.animate(withDuration: 0.2) {
                switch shape {
                case .circle:
                    shadowCornerRadius = min(target.bounds.width, target.bounds.height) / 2
                    target.layer.cornerRadius = shadowCornerRadius
                case .roundedRectangle(let cornerRadius, let corners):
                    shadowCornerRadius = min(cornerRadius, min(target.bounds.width, target.bounds.height) / 2)
                    shadowCorners = corners
                    target.layer.maskedCorners = corners.caMask
                    target.layer.cornerRadius = min(cornerRadius, min(target.bounds.width, target.bounds.height) / 2)
                }
            }
        }
        if let shadow {
            UIView.animate(withDuration: 0.2) {
                let path = UIBezierPath(roundedRect: target.bounds, byRoundingCorners: shadowCorners, cornerRadii: .init(width: shadowCornerRadius, height: shadowCornerRadius))
                target.layer.add(
                    shadow: shadow.updated(
                        \.path, with: path.cgPath
                    )
                )
            }
        }
        layerConfiguration?(target)
    }
}
