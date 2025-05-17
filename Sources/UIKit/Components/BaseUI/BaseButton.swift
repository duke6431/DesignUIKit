//
//  BaseButton.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 16/5/25.
//

import UIKit
import DesignCore

/// A customizable UIButton base class supporting theming and configuration.
/// 
/// This class provides a foundation for buttons that can be styled and themed dynamically.
/// It supports configuration loading, theme application, and visual state animations.
open class BaseButton: UIButton, FConfigurable, FThemableBackground, FThemableShadow, Loggable {
    /// Creates and returns a button object with the specified button type.
    ///
    /// - Parameter buttonType: The button type to use for the button. Defaults to `.custom` if not provided.
    public convenience init(style buttonType: UIButton.ButtonType? = nil) {
        self.init(type: buttonType ?? .custom)
        loadConfiguration()
    }
    
    /// A Boolean value that determines whether the button is highlighted.
    ///
    /// When the button's highlight state changes, an animation adjusts the button's alpha to visually indicate the state.
    open override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) { [weak self] in
                self?.alpha = (self?.isHighlighted ?? false) ? 0.35 : 1
            }
        }
    }
    
    /// Notifies the button that it will move to a new superview.
    ///
    /// This override forwards the event to the configuration object to manage lifecycle events.
    ///
    /// - Parameter newSuperview: The new superview or nil if the button is being removed.
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        configuration?.willMove(toSuperview: newSuperview)
    }
    
    /// Loads and initializes the button's configuration.
    ///
    /// This method sets up the configuration object and assigns the button as its owner.
    open func loadConfiguration() {
        configuration = .init()
        configuration?.owner = self
    }
    
    /// The theme key used to retrieve the background color from the current theme.
    public var backgroundKey: ThemeKey?
    
    /// The theme key used to retrieve the shadow color from the current theme.
    public var shadowKey: ThemeKey?
    
    /// Applies the specified theme to the button.
    ///
    /// This method updates the button's background color and shadow based on the theme keys.
    ///
    /// - Parameter theme: The theme provider supplying colors and styles.
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
}
