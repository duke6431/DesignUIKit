//
//  FSpacer.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2024/02/12.
//
//  A configurable spacer view that can optionally apply a blur effect.
//  Useful for layout spacing and decorative purposes within view hierarchies.
//

import UIKit

/// A configurable spacer view that optionally supports a blur effect.
///
/// `FSpacer` is typically used to insert fixed-width or height spacing within view hierarchies.
/// You can optionally apply a `UIBlurEffect` to the spacer for visual styling.
public final class FSpacer: BaseView, FComponent {
    /// The blur style applied to the spacer. Setting this adds or removes a `UIVisualEffectView`.
    public var blurStyle: UIBlurEffect.Style? {
        didSet {
            if let blurStyle {
                generateBlurIfNeeded(with: blurStyle)
                blurView?.effect = UIBlurEffect(style: blurStyle)
            } else {
                blurView?.removeFromSuperview()
                blurView = nil
            }
        }
    }
    /// An optional closure to perform custom configuration on the spacer.
    public var customConfiguration: ((FSpacer) -> Void)?
    
    /// The internal reference to the blur effect view, if one has been added.
    fileprivate weak var blurView: UIVisualEffectView?
    
    /// Initializes the spacer with optional width and height constraints.
    ///
    /// - Parameters:
    ///   - width: Optional fixed width.
    ///   - height: Optional fixed height.
    public init(width: CGFloat? = nil, height: CGFloat? = nil) {
        super.init(frame: .zero)
        self.configuration?.width = width
        self.configuration?.height = height
    }
    
    /// Called when the spacer is added to a superview. Applies configuration and blur effect if needed.
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configuration?.didMoveToSuperview(superview, with: self)
        generateBlurIfNeeded(with: blurStyle)
        customConfiguration?(self)
    }
    
    /// Lays out subviews and updates layer configuration.
    public override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
    }
    
    /// Adds a blur view to the spacer if it hasn't already been added and the style is provided.
    ///
    /// - Parameter blurStyle: The blur effect style to apply.
    public func generateBlurIfNeeded(with blurStyle: UIBlurEffect.Style?) {
        if blurView != nil { return }
        guard let blurStyle else { return }
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        addSubview(blurEffectView)
        blurEffectView.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
        self.blurView = blurEffectView
    }
    
    /// Sets the blur effect style and returns self for chaining.
    ///
    /// - Parameter style: The blur style to apply.
    /// - Returns: Self for fluent configuration.
    @discardableResult
    public func blurred(_ style: UIBlurEffect.Style) -> Self {
        blurStyle = style
        return self
    }
}
