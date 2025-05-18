//
//  BaseTextView.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2025/05/16.
//
//  A configurable and themable UITextView subclass that supports dynamic background and shadow styling,
//  and integrates with a logging system for lifecycle tracking.
//

import UIKit
import DesignCore

/// `BaseTextView` is a configurable and themable subclass of `UITextView`.
///
/// This class provides a flexible foundation for text views that need to support dynamic configuration and theming, such as background color and shadow. It also integrates with a logging system for lifecycle events.
open class BaseTextView: UITextView, FConfigurable, FThemableBackground, FThemableShadow, Loggable {
    /// Initializes a new `BaseTextView` instance with an optional frame.
    ///
    /// - Parameter frame: The frame rectangle for the view, measured in points. Defaults to `.zero`.
    public init(frame: CGRect = .zero) {
        super.init(frame: frame, textContainer: nil)
        loadConfiguration()
    }
    
    /// Unavailable initializer for decoding from a storyboard or nib.
    /// This class does not support initialization from Interface Builder.
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    /// Notifies the view that it is about to move to a new superview.
    ///
    /// This override ensures that the configuration object is also notified, allowing it to perform any necessary setup or teardown when the view's superview changes.
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        configuration?.willMove(toSuperview: newSuperview)
    }
    
    /// Loads and assigns a new configuration object to the view.
    ///
    /// This method initializes the configuration and sets its owner to the current view instance.
    open func loadConfiguration() {
        configuration = .init()
        configuration?.owner = self
    }
    
    /// The theme key used to determine the background color of the text view.
    public var backgroundKey: ThemeKey?
    /// The theme key used to determine the shadow color of the text view.
    public var shadowKey: ThemeKey?
    
    /// Applies the provided theme to the text view.
    ///
    /// - Parameter theme: The theme provider to use for resolving colors and styles.
    ///
    /// This method updates the background color and shadow of the view based on the associated theme keys.
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

