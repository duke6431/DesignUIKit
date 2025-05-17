
//
//  BaseScrollView.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2025/05/16.
//
//  A configurable and themable UIScrollView subclass designed for use in DesignUIKit.
//  Provides runtime configuration, dynamic background and shadow theming, and logging.
//

import UIKit
import DesignCore

/// A configurable and themable UIScrollView subclass.
///
/// `BaseScrollView` is designed to provide a flexible scroll view that supports dynamic configuration and theming for background and shadow properties.
/// It integrates with the FConfigurable, FThemableBackground, and FThemableShadow protocols, and supports logging.
open class BaseScrollView: UIScrollView, FConfigurable, FThemableBackground, FThemableShadow, Loggable {
    /// Initializes a new instance of `BaseScrollView` with the given frame.
    ///
    /// - Parameter frame: The frame rectangle for the view, measured in points. Defaults to `.zero`.
    public override init(frame: CGRect = .zero) {
        super.init(frame: .zero)
        loadConfiguration()
    }
    
    /// Required initializer for decoding. Not available.
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    /// Adds a subview to the scroll view.
    ///
    /// - Parameter view: The view to be added as a subview.
    /// - Note: This override disables automatic parent constraint application for the subview's configuration.
    open override func addSubview(_ view: UIView) {
        view.configuration?.shouldConstraintWithParent = false
        super.addSubview(view)
    }
    
    /// Notifies the scroll view that it will be added to a superview.
    ///
    /// - Parameter newSuperview: The new superview of the scroll view.
    /// - Note: Forwards the event to the configuration object.
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        configuration?.willMove(toSuperview: newSuperview)
    }
    
    /// Loads and sets up the configuration for the scroll view.
    ///
    /// This method initializes the configuration object and sets its owner to the scroll view.
    open func loadConfiguration() {
        configuration = .init()
        configuration?.owner = self
    }
    
    /// The key for theming the background color.
    public var backgroundKey: ThemeKey?
    /// The key for theming the shadow color.
    public var shadowKey: ThemeKey?
    
    /// Applies the provided theme to the scroll view.
    ///
    /// - Parameter theme: The theme provider containing color definitions.
    /// - Note: Applies background and shadow colors using their respective theme keys if set.
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
    
    /// Deinitializes the scroll view and logs the deallocation.
    deinit {
        logger.trace("Deinitialized \(self)")
    }
}
