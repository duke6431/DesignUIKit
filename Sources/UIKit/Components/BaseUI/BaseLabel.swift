
//
//  BaseLabel.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 16/5/25.
//
//  BaseLabel
//
//  A customizable UILabel subclass that supports content insets and dynamic theming.
//  This class is designed to be used as a base for labels that require additional
//  layout flexibility or visual customization via themes.
//

import UIKit
import DesignCore

/// A customizable UILabel supporting content insets and theming.
///
/// `BaseLabel` provides a UILabel subclass that allows for:
/// - Customizable text insets via the `contentInsets` property.
/// - Dynamic theming support for background color and shadow using theme keys.
/// - Proper layout handling for multi-line labels and stack views.
///
/// - Important: This class is intended to be subclassed or instantiated directly
///   when you need a label with additional layout and theming features.
open class BaseLabel: UILabel, FConfigurable, FThemableBackground, FThemableShadow, Loggable {
    /// Insets to apply to the label's text content.
    ///
    /// Adjust this property to increase or decrease the padding inside the label.
    /// The default value is `.zero`.
    var contentInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
    
    /// Initializes a new BaseLabel instance with the given frame.
    ///
    /// - Parameter frame: The frame rectangle for the label, measured in points. Default is `.zero`.
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
    
    /// Notifies the label that it is about to move to a new superview.
    ///
    /// This override ensures the configuration is also notified of the move.
    /// - Parameter newSuperview: The new superview the label is moving to, or `nil` if being removed.
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        configuration?.willMove(toSuperview: newSuperview)
    }
    
    /// Loads and sets up the configuration for the label.
    ///
    /// This method is called during initialization and can be overridden for custom configuration.
    open func loadConfiguration() {
        configuration = .init()
        configuration?.owner = self
    }
    
    /// Draws the label's text, applying `contentInsets`.
    ///
    /// - Parameter rect: The rectangle in which to draw the text.
    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInsets))
    }
    
    /// The natural size for the label, factoring in `contentInsets`.
    ///
    /// This override ensures the intrinsic content size accounts for the insets.
    open override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + contentInsets.left + contentInsets.right,
                      height: size.height + contentInsets.top + contentInsets.bottom)
    }
    
    /// The bounds of the label.
    ///
    /// This override updates `preferredMaxLayoutWidth` to support multi-line labels
    /// within stack views, accounting for `contentInsets`.
    open override var bounds: CGRect {
        didSet {
            // Ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (contentInsets.left + contentInsets.right)
        }
    }
    
    /// The theme key used for the label's background color.
    public var backgroundKey: ThemeKey?
    /// The theme key used for the label's shadow color.
    public var shadowKey: ThemeKey?
    
    /// Applies the provided theme to the label.
    ///
    /// - Parameter theme: The theme provider to use for retrieving colors.
    ///
    /// This method updates the background color and shadow based on the
    /// `backgroundKey` and `shadowKey` properties, if set.
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
    
    /// Logs deinitialization of the label for debugging purposes.
    deinit {
        logger.trace("Deinitialized \(self)")
    }
}
