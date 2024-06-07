//
//  File.swift
//
//
//  Created by Duc Minh Nguyen on 2/20/24.
//

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif
import DesignCore
import DesignExts
import SnapKit
import Combine

public protocol FConfigurable: AnyObject, Chainable {
    var configuration: FConfiguration? { get }
    
    @discardableResult func frame(height: CGFloat) -> Self
    @discardableResult func frame(width: CGFloat) -> Self
    @discardableResult func frame(width: CGFloat, height: CGFloat) -> Self
    @discardableResult func centerInParent() -> Self
    @discardableResult func centerInParent(offset: CGSize) -> Self
    @discardableResult func ratio(_ ratio: CGFloat) -> Self
    @discardableResult func padding() -> Self
    @discardableResult func padding(_ padding: CGFloat) -> Self
    @discardableResult func padding(_ edges: NSDirectionalRectEdge, _ padding: CGFloat) -> Self
    @discardableResult func offset(_ size: CGSize) -> Self
    @discardableResult func offset(width: CGFloat, height: CGFloat) -> Self
    @discardableResult func background(_ color: BColor) -> Self
    @discardableResult func shaped(_ shape: FShape) -> Self
    @discardableResult func shadow(_ shadow: CALayer.ShadowConfiguration) -> Self
    @discardableResult func attachToParent(_ status: Bool) -> Self
    @discardableResult func opacity(_ opacity: CGFloat) -> Self
    @discardableResult func layout(_ layoutConfiguration: @escaping (_ make: ConstraintMaker, _ superview: BView) -> Void) -> Self
    @discardableResult func layer(_ layerConfiguration: @escaping (UIView) -> Void) -> Self
}

public class FConfiguration: Chainable {
    public var width: CGFloat?
    public var height: CGFloat?
    public var offset: CGSize = .zero
    public var shadow: CALayer.ShadowConfiguration?
    public var shape: FShape?
    public var backgroundColor: BColor = .clear
    public var containerPadding: NSDirectionalEdgeInsets?
    public var ratio: CGFloat?
    public var opacity: CGFloat = 1
    public var centerOffset: CGSize?
    public var layoutConfiguration: ((_ make: ConstraintMaker, _ superview: BView) -> Void)?
    public var layerConfiguration: ((UIView) -> Void)?
    
    public var shouldConstraintWithParent: Bool = true
    public weak var owner: BView?
    
    
    public func didMoveToSuperview(_ superview: BView?, with target: BView) {
        target.backgroundColor = backgroundColor
        target.alpha = opacity
        if let centerOffset, let superview {
            target.snp.makeConstraints {
                $0.centerX.equalTo(superview.safeAreaLayoutGuide).offset(centerOffset.width)
                $0.centerY.equalTo(superview.safeAreaLayoutGuide).offset(centerOffset.height)
            }
        } else if shouldConstraintWithParent, let superview {
            target.snp.remakeConstraints {
                $0.top.equalTo(superview.safeAreaLayoutGuide).offset(offset.height + (containerPadding?.top ?? 0))
                $0.leading.equalTo(superview.safeAreaLayoutGuide).offset(offset.width + (containerPadding?.leading ?? 0))
                $0.trailing.equalTo(superview.safeAreaLayoutGuide).offset(offset.width - (containerPadding?.trailing ?? 0))
                $0.bottom.equalTo(superview.safeAreaLayoutGuide).offset(offset.height - (containerPadding?.bottom ?? 0))
            }
        }
        target.snp.makeConstraints {
            if let width, width > 0 { $0.width.equalTo(width) }
            if let height, height > 0 { $0.height.equalTo(height) }
            if let ratio { $0.width.equalTo(target.snp.height).multipliedBy(ratio) }
        }
        if let layoutConfiguration, let superview {
            target.snp.makeConstraints {
                layoutConfiguration($0, superview)
            }
        }
    }
    
    public func updateLayers(for target: BView) {
        var shadowCornerRadius: CGFloat = 0
        var shadowCorners: BRectCorner = .allCorners
        if let shape {
            target.clipsToBounds = true
            BView.animate(withDuration: 0.2) {
                switch shape {
                case .circle:
                    shadowCornerRadius = min(target.bounds.width, target.bounds.height) / 2
#if canImport(UIKit)
                    target.layer.cornerRadius = shadowCornerRadius
#else
                    target.layer?.cornerRadius = min(target.bounds.width, target.bounds.height) / 2
#endif
                case .roundedRectangle(let cornerRadius, let corners):
                    shadowCornerRadius = min(cornerRadius, min(target.bounds.width, target.bounds.height) / 2)
                    shadowCorners = corners
#if canImport(UIKit)
                    target.layer.maskedCorners = corners.caMask
                    target.layer.cornerRadius = min(cornerRadius, min(target.bounds.width, target.bounds.height) / 2)
#else
                    target.layer?.maskedCorners = corners.caMask
                    target.layer?.cornerRadius = min(cornerRadius, min(target.bounds.width, target.bounds.height) / 2)
#endif
                }
            }
        }
        if let shadow {
            BView.animate(withDuration: 0.2) {
                let path = UIBezierPath(roundedRect: target.bounds, byRoundingCorners: shadowCorners, cornerRadii: .init(width: shadowCornerRadius, height: shadowCornerRadius))
#if canImport(UIKit)
                target.layer.add(
                    shadow: shadow.updated(
                        \.path, with: path.cgPath
                    )
                )
#else
                target.layer?.add(
                    shadow: shadow.updated(
                        \.path, with: BBezierPath(rect: target.bounds).cgPath
                    )
                )
#endif
            }
        }
        layerConfiguration?(target)
    }
}
