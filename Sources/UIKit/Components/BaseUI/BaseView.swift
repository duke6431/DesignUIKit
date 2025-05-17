//
//  BaseView.swift
//
//
//  Created by Duc IT. Nguyen Minh on 15/02/2024.
//

import UIKit
import DesignCore

/// A configurable and themable UIView subclass that supports background and shadow theming.
///
/// This class conforms to `FConfigurable`, `FThemableBackground`, `FThemableShadow`, and `Loggable` protocols,
/// providing a base view with configurable appearance and theming capabilities.
open class BaseView: UIView, FConfigurable, FThemableBackground, FThemableShadow, Loggable {
    
    /// Initializes a new instance of `BaseView` with the specified frame.
    /// - Parameter frame: The frame rectangle for the view, defaulting to `.zero`.
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        loadConfiguration()
    }
    
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    /// Called when the view is about to be added to a superview.
    /// - Parameter newSuperview: The new superview of the view.
    ///
    /// This method forwards the event to the internal configuration for lifecycle management.
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        configuration?.willMove(toSuperview: newSuperview)
    }
    
    /// Loads and initializes the view's configuration.
    ///
    /// This method can be overridden by subclasses to provide custom configuration setup.
    open func loadConfiguration() {
        configuration = .init()
    }
    
    /// The theme key used to resolve the background color.
    public var backgroundKey: ThemeKey?
    
    /// The theme key used to resolve the shadow color.
    public var shadowKey: ThemeKey?
    
    /// Applies the provided theme to the view.
    /// - Parameter theme: The theme provider used to fetch themed colors.
    ///
    /// This method updates the background color and shadow color based on the theme keys.
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
    
    /// Deinitializes the view and logs the deinitialization event.
    deinit {
        logger.trace("Deinitialized \(self)")
    }
}
