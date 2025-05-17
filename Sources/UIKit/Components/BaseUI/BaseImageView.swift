//
//  BaseImageView.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 16/5/25.
//
//  BaseImageView
//  Copyright © 2024 Duc Nguyen. All rights reserved.
//
//  A configurable and themable UIImageView subclass for use in DesignUIKit.
//

import UIKit
import DesignCore

/// `BaseImageView` is a configurable and themable subclass of `UIImageView`.
///
/// This class is designed to provide a flexible image view that supports runtime configuration and dynamic theming,
/// including background and shadow theming. It is intended for use as a base class in UI components where
/// consistent styling and configuration are required.
open class BaseImageView: UIImageView, FConfigurable, FThemableBackground, FThemableShadow, Loggable {
    
    /// Initializes a new `BaseImageView` instance with the specified frame.
    ///
    /// - Parameter frame: The frame rectangle for the view, measured in points. Defaults to `.zero`.
    public override init(frame: CGRect = .zero) {
        super.init(frame: .zero)
        loadConfiguration()
    }
    
    /// Initializes a new `BaseImageView` with the specified image.
    ///
    /// - Parameter image: The initial image to display in the image view.
    public override init(image: UIImage?) {
        super.init(image: image)
        loadConfiguration()
    }
    
    /// Initializes a new `BaseImageView` with the specified image and highlighted image.
    ///
    /// - Parameters:
    ///   - image: The initial image to display in the image view.
    ///   - highlightedImage: The image to display when the image view is highlighted.
    public override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        loadConfiguration()
    }
    
    /// Unavailable initializer. Use other initializers instead.
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    /// Called before the view is added to a superview.
    ///
    /// This override allows the view to perform configuration updates
    /// just before being added to a new superview.
    /// - Parameter newSuperview: The new superview the view will be added to.
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        configuration?.willMove(toSuperview: newSuperview)
    }
    
    /// Loads the initial configuration for the image view.
    ///
    /// This method creates and assigns a new configuration object and sets its owner to self.
    open func loadConfiguration() {
        configuration = .init()
        configuration?.owner = self
    }
    
    /// The key used to look up the background color in a theme.
    public var backgroundKey: ThemeKey?
    /// The key used to look up the shadow color in a theme.
    public var shadowKey: ThemeKey?
    
    /// Applies the given theme to the image view.
    ///
    /// - Parameter theme: The theme provider used to resolve colors for background and shadow.
    ///
    /// If `backgroundKey` is set, updates the background color. If `shadowKey` is set,
    /// updates the shadow color accordingly.
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
    
    /// Logs when the image view is deallocated.
    deinit {
        logger.trace("Deinitialized \(self)")
    }
}
