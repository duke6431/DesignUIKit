//
//  FConfigurable.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2024/02/20.
//
//  Defines the `FConfigurable` protocol for UI components that support fluent configuration,
//  including layout, appearance, and behavior modifiers.
//  Provides the `FConfiguration` class to encapsulate and apply these configurations.
//

import UIKit
import DesignCore
import DesignExts
import SnapKit

/// A protocol that defines a configurable UI component supporting fluent interface style configuration.
/// Components conforming to `FConfigurable` can be assigned configurations related to layout, appearance,
/// modifiers, and other UI behaviors.
public protocol FConfigurable: AnyObject, FAssignable, Chainable {
    /// The current configuration applied to the component.
    var configuration: FConfiguration? { get }
    
    /// Sets the frame height of the component.
    /// - Parameter height: The height to set.
    /// - Returns: Self for chaining.
    @discardableResult func frame(height: CGFloat) -> Self
    
    /// Sets the frame width of the component.
    /// - Parameter width: The width to set.
    /// - Returns: Self for chaining.
    @discardableResult func frame(width: CGFloat) -> Self
    
    /// Sets the frame width and height of the component.
    /// - Parameters:
    ///   - width: The width to set.
    ///   - height: The height to set.
    /// - Returns: Self for chaining.
    @discardableResult func frame(width: CGFloat, height: CGFloat) -> Self
    
    /// Sets the layout priority for constraints.
    /// - Parameter priority: The priority to assign.
    /// - Returns: Self for chaining.
    @discardableResult func layoutPriority(_ priority: ConstraintPriority) -> Self
    
    /// Centers the component in its parent view.
    /// - Returns: Self for chaining.
    @discardableResult func centerInParent() -> Self
    
    /// Centers the component in its parent view with an offset.
    /// - Parameter offset: The offset to apply.
    /// - Returns: Self for chaining.
    @discardableResult func centerInParent(offset: CGSize) -> Self
    
    /// Sets the aspect ratio (width/height) of the component.
    /// - Parameter ratio: The ratio value.
    /// - Returns: Self for chaining.
    @discardableResult func ratio(_ ratio: CGFloat) -> Self
    
    /// Applies default padding to the component.
    /// - Returns: Self for chaining.
    @discardableResult func padding() -> Self
    
    /// Applies uniform padding to all edges of the component.
    /// - Parameter padding: The padding value.
    /// - Returns: Self for chaining.
    @discardableResult func padding(_ padding: CGFloat) -> Self
    
    /// Applies padding to specified edges.
    /// - Parameters:
    ///   - edges: The edges to apply padding to.
    ///   - padding: The padding value.
    /// - Returns: Self for chaining.
    @discardableResult func padding(_ edges: NSDirectionalRectEdge, _ padding: CGFloat) -> Self
    
    /// Applies padding using a predefined spacing style.
    /// - Parameter style: The spacing style to apply.
    /// - Returns: Self for chaining.
    @discardableResult func padding(with style: SpacingSystem.CommonSpacing) -> Self
    
    /// Applies padding to specified edges using a predefined spacing style.
    /// - Parameters:
    ///   - edges: The edges to apply padding to.
    ///   - style: The spacing style to apply.
    /// - Returns: Self for chaining.
    @discardableResult func padding(_ edges: NSDirectionalRectEdge, with style: SpacingSystem.CommonSpacing) -> Self
    
    /// Sets the offset for the component's position.
    /// - Parameter size: The offset size.
    /// - Returns: Self for chaining.
    @discardableResult func offset(_ size: CGSize) -> Self
    
    /// Sets the offset for the component's position with width and height values.
    /// - Parameters:
    ///   - width: The horizontal offset.
    ///   - height: The vertical offset.
    /// - Returns: Self for chaining.
    @discardableResult func offset(width: CGFloat, height: CGFloat) -> Self
    
    /// Sets the background color of the component.
    /// - Parameter color: The background color.
    /// - Returns: Self for chaining.
    @discardableResult func background(_ color: UIColor) -> Self
    
    /// Applies a shape style to the component.
    /// - Parameter shape: The shape to apply.
    /// - Returns: Self for chaining.
    @discardableResult func shaped(_ shape: FShape) -> Self
    
    /// Applies a shadow configuration to the component.
    /// - Parameter shadow: The shadow configuration.
    /// - Returns: Self for chaining.
    @discardableResult func shadow(_ shadow: CALayer.ShadowConfiguration) -> Self
    
    /// Sets whether the component should ignore the safe area.
    /// - Parameter status: `true` to ignore safe area, otherwise `false`.
    /// - Returns: Self for chaining.
    @discardableResult func ignoreSafeArea(_ status: Bool) -> Self
    
    /// Sets whether the component should be attached to its parent view with constraints.
    /// - Parameter status: `true` to attach, otherwise `false`.
    /// - Returns: Self for chaining.
    @discardableResult func attachToParent(_ status: Bool) -> Self
    
    /// Sets the opacity of the component.
    /// - Parameter opacity: The opacity value (0 to 1).
    /// - Returns: Self for chaining.
    @discardableResult func opacity(_ opacity: CGFloat) -> Self
    
    /// Applies custom layout constraints using a closure.
    /// - Parameter layoutConfiguration: Closure receiving the constraint maker and superview.
    /// - Returns: Self for chaining.
    @discardableResult func layout(_ layoutConfiguration: @escaping (_ make: ConstraintMaker, _ superview: UIView) -> Void) -> Self
    
    /// Enables or disables layer animation.
    /// - Parameter isEnabled: `true` to enable animation, otherwise `false`.
    /// - Returns: Self for chaining.
    @discardableResult func shouldAnimateLayer(_ isEnabled: Bool) -> Self
    
    /// Applies custom layer configuration using a closure.
    /// - Parameter layerConfiguration: Closure receiving the target view.
    /// - Returns: Self for chaining.
    @discardableResult func layer(_ layerConfiguration: @escaping (UIView) -> Void) -> Self
    
    /// Applies a modifier to the component.
    /// - Parameter modifier: The modifier to apply.
    /// - Returns: Self for chaining.
    @discardableResult func modified(with modifier: FModifier) -> Self
    
    /// Clears all applied modifiers from the component.
    /// - Returns: Self for chaining.
    @discardableResult func clearModifiers() -> Self
}

/// Represents the configuration state of an `FConfigurable` component,
/// encapsulating layout, appearance, modifiers, and other UI-related settings.
public class FConfiguration: Chainable {
    /// The list of modifiers applied to the component.
    var modifiers: [FModifier] = []
    
    /// Flag indicating whether to clear all modifiers.
    var clearModifiers: Bool = false
    
    /// The width constraint value.
    public var width: CGFloat?
    
    /// The height constraint value.
    public var height: CGFloat?
    
    /// The offset to apply to the component's position.
    public var offset: CGSize = .zero
    
    /// The shadow configuration to apply.
    public var shadow: CALayer.ShadowConfiguration?
    
    /// The shape style to apply.
    public var shape: FShape?
    
    /// The background color of the component.
    public var backgroundColor: UIColor = .clear
    
    /// The padding insets to apply to the container.
    public var containerPadding: NSDirectionalEdgeInsets?
    
    /// The aspect ratio (width/height) constraint.
    public var ratio: CGFloat?
    
    /// The opacity of the component.
    public var opacity: CGFloat = 1
    
    /// The offset to apply when centering in the parent view.
    public var centerOffset: CGSize?
    
    /// The priority of layout constraints.
    public var layoutPriority: ConstraintPriority = .required
    
    /// Custom layout configuration closure.
    public var layoutConfiguration: ((_ make: ConstraintMaker, _ superview: UIView) -> Void)?
    
    /// Flag indicating whether to animate layer changes.
    public var shoudAnimateLayerChanges: Bool = false
    
    /// Custom layer configuration closure.
    public var layerConfiguration: ((UIView) -> Void)?
    
    /// Flag indicating whether to ignore safe area constraints.
    public var shouldIgnoreSafeArea: Bool = false
    
    /// Flag indicating whether to constraint the component with its parent.
    public var shouldConstraintWithParent: Bool = true
    
    /// Weak reference to the owning view.
    public weak var owner: UIView?
    
    /// Called before the component moves to a new superview.
    /// - Parameter newSuperview: The new superview the component will move to.
    func willMove(toSuperview newSuperview: UIView?) {
        guard let newSuperview = newSuperview as? FBodyComponent else { return }
        if !clearModifiers {
            modifiers = (newSuperview.configuration?.modifiers ?? []) + modifiers
        }
    }
    
    /// Called after the component has moved to a superview, applying layout and appearance configurations.
    /// - Parameters:
    ///   - superview: The superview the component moved to.
    ///   - target: The target component being configured.
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
    
    /// Updates the layers of the target view based on the current configuration.
    /// - Parameter target: The view to update.
    public func updateLayers(for target: UIView) {
        var shadowCornerRadius: CGFloat = 0
        var shadowCorners: UIRectCorner = .allCorners
        if let shape {
            target.clipsToBounds = true
            apply {
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
            apply {
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
    
    /// Applies the given animation configuration to an animation block.
    /// - Parameters:
    ///   - configuration: The animation configuration to apply. Defaults to `.default`.
    ///   - animation: The animation block to execute.
    fileprivate func apply(configuration: AnimationConfiguration = .default, to animation: @escaping () -> Void) {
        if shoudAnimateLayerChanges {
            UIView.animate(withDuration: configuration.duration, delay: configuration.delay, animations: animation)
        } else {
            animation()
        }
    }
}

/// Represents animation timing configuration for layer animations.
fileprivate struct AnimationConfiguration {
    /// The default animation configuration with a 0.25 second duration and no delay.
    static let `default`: Self = .init(duration: 0.25, delay: 0)
    
    /// The duration of the animation.
    let duration: TimeInterval
    
    /// The delay before the animation starts.
    let delay: TimeInterval
}
