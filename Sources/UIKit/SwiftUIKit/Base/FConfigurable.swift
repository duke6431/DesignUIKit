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
    
    /// Centers the component in its parent view with a given offset.
    ///
    /// - Parameter offset: The horizontal and vertical offset to apply when centering.
    /// - Returns: Self for method chaining.
    @discardableResult func centerInParent(offset: CGSize) -> Self
    
    /// Centers the component along the specified axis in its parent view.
    ///
    /// - Parameter axis: The axis (horizontal or vertical) along which to center the component.
    /// - Returns: Self for method chaining.
    @discardableResult func center(axis: FAxis) -> Self
    
    /// Centers the component along a specific axis with an optional offset.
    ///
    /// - Parameters:
    ///   - axis: The axis to center on.
    ///   - offset: The amount of offset to apply from the center.
    /// - Returns: Self for method chaining.
    @discardableResult func center(axis: FAxis, offset: CGFloat) -> Self
    
    /// Sets the width-to-height ratio for the component's layout constraints.
    ///
    /// - Parameter ratio: The ratio to apply (e.g., 1.0 for square).
    /// - Returns: Self for method chaining.
    @discardableResult func ratio(_ ratio: CGFloat) -> Self
    
    /// Applies default padding to the component.
    /// - Returns: Self for chaining.
    @discardableResult func padding() -> Self
    
    /// Applies uniform padding to all edges of the component.
    /// - Parameter padding: The padding value.
    /// - Returns: Self for chaining.
    @discardableResult func padding(_ padding: CGFloat) -> Self
    /// Applies padding to specific directional edges of the component.
    ///
    /// - Parameters:
    ///   - edges: The edges to apply the padding to.
    ///   - padding: The padding value to apply.
    /// - Returns: Self for method chaining.
    @discardableResult func padding(_ edges: FDirectionalRectEdge, _ padding: CGFloat) -> Self
    
    /// Applies uniform padding to all edges using a predefined spacing style.
    ///
    /// - Parameter style: The spacing style to apply.
    /// - Returns: Self for method chaining.
    @discardableResult func padding(with style: SpacingSystem.CommonSpacing) -> Self
    
    /// Applies padding to specific directional edges using a predefined spacing style.
    ///
    /// - Parameters:
    ///   - edges: The edges to apply the padding to.
    ///   - style: The spacing style to apply.
    /// - Returns: Self for method chaining.
    @discardableResult func padding(_ edges: FDirectionalRectEdge, with style: SpacingSystem.CommonSpacing) -> Self
    
    /// Ignores layout constraints on specific directional edges of the component.
    ///
    /// - Parameter edges: The edges to ignore.
    /// - Returns: Self for method chaining.
    @discardableResult func ignore(edges: FDirectionalRectEdge) -> Self
    
    /// Applies a horizontal and vertical offset to the component's position.
    ///
    /// - Parameter size: The offset to apply as a `CGSize`.
    /// - Returns: Self for method chaining.
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
    
    /// The shape style to apply to the component, such as circle or rounded rectangle.
    public var shape: FShape?
    
    /// The background color to apply to the component.
    public var backgroundColor: UIColor = .clear
    
    /// The directional padding to apply around the component inside its container.
    public var containerPadding: [FDirectionalRectEdge: CGFloat] = .init(
        uniqueKeysWithValues: FDirectionalRectEdge.all.rawEdges.map { ($0, 0) }
    )
    
    /// The width-to-height ratio constraint to apply, if any.
    public var ratio: CGFloat?
    
    /// The opacity of the component, ranging from 0.0 (transparent) to 1.0 (opaque).
    public var opacity: CGFloat = 1
    
    /// Centering offset adjustments for horizontal and vertical axes.
    public var centerOffset: [FAxis: CGFloat] = [:]
    
    /// The layout constraint priority for applying sizing and positioning rules.
    public var layoutPriority: ConstraintPriority = .required
    
    /// A closure for applying custom layout constraints using SnapKit.
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
    
    /// Increments the existing padding value for a specific directional edge.
    ///
    /// If a value already exists for the given edge, the new padding is added on top of it.
    /// Otherwise, it sets the padding to the provided value.
    ///
    /// - Parameters:
    ///   - padding: The padding amount to add or set.
    ///   - edge: The directional edge to apply the padding to.
    func update(_ padding: CGFloat, for edge: FDirectionalRectEdge) {
        var finalPadding: CGFloat = padding
        if let currentPadding = containerPadding[edge] {
            finalPadding += currentPadding
        }
        containerPadding[edge] = finalPadding
    }
    
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
        guard let superview else { return }
        modifiers.forEach { $0.body(target) }
        target.backgroundColor = backgroundColor
        target.alpha = opacity
        if shouldConstraintWithParent {
            target.snp.remakeConstraints {
                let target: ConstraintRelatableTarget = shouldIgnoreSafeArea ? superview : superview.safeAreaLayoutGuide
                if let centerOffset = centerOffset[.vertical] {
                    $0.centerX.equalTo(superview.safeAreaLayoutGuide)
                        .offset(centerOffset).priority(layoutPriority)
                } else {
                    if let padding = containerPadding[.leading] {
                        $0.leading.equalTo(target).offset(offset.width + padding).priority(layoutPriority)
                    }
                    if let padding = containerPadding[.trailing] {
                        $0.trailing.equalTo(target).offset(offset.width - padding).priority(layoutPriority)
                    }
                }
                if let centerOffset = centerOffset[.horizontal] {
                    $0.centerY.equalTo(superview.safeAreaLayoutGuide)
                        .offset(centerOffset).priority(layoutPriority)
                } else {
                    if let padding = containerPadding[.top] {
                        $0.top.equalTo(target).offset(offset.height + padding).priority(layoutPriority)
                    }
                    if let padding = containerPadding[.bottom] {
                        $0.bottom.equalTo(target).offset(offset.height - padding).priority(layoutPriority)
                    }
                }
            }
        }
        target.snp.makeConstraints {
            if let width, width > 0 { $0.width.equalTo(width).priority(layoutPriority) }
            if let height, height > 0 { $0.height.equalTo(height).priority(layoutPriority) }
            if let ratio { $0.width.equalTo(target.snp.height).multipliedBy(ratio).priority(layoutPriority) }
        }
        if let layoutConfiguration {
            target.snp.makeConstraints { layoutConfiguration($0, superview) }
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
                    shadowCornerRadius = min(
                        cornerRadius,
                        min(
                            target.bounds.width,
                            target.bounds.height
                        ) / 2
                    )
                    shadowCorners = corners
                    target.layer.maskedCorners = corners.caMask
                    target.layer.cornerRadius = min(
                        cornerRadius,
                        min(
                            target.bounds.width,
                            target.bounds.height
                        ) / 2
                    )
                }
            }
        }
        if let shadow {
            apply {
                let path = UIBezierPath(
                    roundedRect: target.bounds,
                    byRoundingCorners: shadowCorners,
                    cornerRadii: .init(
                        width: shadowCornerRadius,
                        height: shadowCornerRadius
                    )
                )
                target.layer.add(
                    shadow: shadow.updated(
                        \.path, with: path.cgPath
                    )
                )
            }
        }
        layerConfiguration?(target)
    }
    
    /// Applies the given animation configuration when executing the provided animation block.
    /// If `shoudAnimateLayerChanges` is enabled, the animation block will run inside a `UIView.animate` call.
    /// Otherwise, it runs immediately without animation.
    ///
    /// - Parameters:
    ///   - configuration: The animation timing configuration to use. Defaults to `.default`.
    ///   - animation: The animation block to execute.
    fileprivate func apply(configuration: AnimationConfiguration = .default, to animation: @escaping () -> Void) {
        if shoudAnimateLayerChanges {
            UIView.animate(
                withDuration: configuration.duration,
                delay: configuration.delay,
                animations: animation
            )
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
