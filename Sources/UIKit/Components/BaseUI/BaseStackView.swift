//
//  BaseStackView.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 16/5/25.
//

import UIKit
import DesignCore

/// A configurable and themable subclass of `UIStackView` that supports background and shadow theming.
/// 
/// `BaseStackView` conforms to `FConfigurable`, `FThemableBackground`, `FThemableShadow`, and `Loggable` protocols,
/// providing a flexible stack view that can be easily customized and themed.
/// 
/// Use this class to create stack views that automatically apply theme colors and shadows, and support custom configurations.
open class BaseStackView: UIStackView, FConfigurable, FThemableBackground, FThemableShadow, Loggable {
    
    /// Initializes a new `BaseStackView` instance with an optional frame.
    /// - Parameter frame: The frame rectangle for the view, defaulting to `.zero`.
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        loadConfiguration()
    }
    
    /// Initializes a new `BaseStackView` instance with an array of arranged subviews.
    /// - Parameter views: The array of `UIView` instances to be arranged by the stack view.
    public convenience init(arrangedSubviews views: [UIView]) {
        self.init(frame: .zero)
        views.forEach(addArrangedSubview)
        loadConfiguration()
    }
    
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    /// Initializes a new `BaseStackView` instance from a decoder.
    /// - Parameter coder: The decoder to initialize from.
    public required init(coder: NSCoder) {
        super.init(coder: coder)
        loadConfiguration()
    }
    
    /// Adds a view to the end of the arrangedSubviews array.
    /// Overrides `UIStackView`'s implementation to disable automatic constraint with parent on the added view's configuration.
    /// - Parameter view: The view to add as an arranged subview.
    open override func addArrangedSubview(_ view: UIView) {
        view.configuration?.shouldConstraintWithParent = false
        super.addArrangedSubview(view)
    }
    
    /// Notifies the view that it is about to be added to a superview.
    /// Calls the configuration's `willMove(toSuperview:)` method to handle any necessary updates.
    /// - Parameter newSuperview: The new superview the view will move to.
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        configuration?.willMove(toSuperview: newSuperview)
    }
    
    /// Loads and initializes the configuration for the stack view.
    /// This method sets up the configuration and assigns the owner.
    open func loadConfiguration() {
        configuration = .init()
        configuration?.owner = self
    }
    
    /// The theme key used to apply the background color.
    public var backgroundKey: ThemeKey?
    
    /// The theme key used to apply the shadow color.
    public var shadowKey: ThemeKey?
    
    /// Applies the given theme to the stack view, updating background and shadow colors based on the theme keys.
    /// - Parameter theme: The `ThemeProvider` instance providing theme colors.
    open func apply(theme: ThemeProvider) {
        if let backgroundKey {
            configuration?.backgroundColor = theme.color(key: backgroundKey)
            backgroundColor = theme.color(key: backgroundKey)
        }
        if let shadowKey {
            configuration?.shadow = configuration?.shadow?.custom {
                $0.color = theme.color(key: shadowKey)
            }
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    /// Called when the instance is being deallocated.
    /// Logs the deinitialization event.
    deinit {
        logger.trace("Deinitialized \(self)")
    }
}
