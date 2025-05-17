
//
//  BaseTextField.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 16/5/25.
//
//  BaseTextField is a configurable and themable UITextField subclass designed for use in customizable UI component systems.
//

import UIKit
import DesignCore

/// A configurable and themable `UITextField` subclass.
///
/// `BaseTextField` provides a foundation for text field components that require dynamic configuration and theme support. It integrates with configuration and theming protocols to enable background color and shadow customization via theme keys.
open class BaseTextField: UITextField, FConfigurable, FThemableBackground, FThemableShadow, Loggable {
    
    /// Initializes a new `BaseTextField` instance with an optional frame.
    ///
    /// - Parameter frame: The frame rectangle for the view, measured in points. Defaults to `.zero`.
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        loadConfiguration()
    }
    
    /// Unavailable. Use `init(frame:)` instead.
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    /// Notifies the text field that it is about to move to a new superview.
    ///
    /// This override ensures that the configuration is updated as the text field moves in the view hierarchy.
    /// - Parameter newSuperview: The new superview of the view.
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        configuration?.willMove(toSuperview: newSuperview)
    }
    
    /// Loads the configuration for the text field.
    ///
    /// This method initializes the configuration object and assigns ownership to the text field.
    open func loadConfiguration() {
        configuration = .init()
        configuration?.owner = self
    }
    
    /// The key used to determine the background color from the theme.
    public var backgroundKey: ThemeKey?
    /// The key used to determine the shadow color from the theme.
    public var shadowKey: ThemeKey?
    
    /// Applies the given theme to the text field.
    ///
    /// This method updates the background color and shadow properties based on the provided theme and the configured theme keys.
    /// - Parameter theme: The theme provider used to supply colors.
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
    
    /// Deinitializes the text field and logs the deinitialization event.
    deinit {
        logger.trace("Deinitialized \(self)")
    }
}
