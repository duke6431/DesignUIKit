//
//  FLabel.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2024/02/11.
//
//  A customizable label component supporting theming and fluent configuration.
//

import UIKit
import DesignCore

/// A customizable label component supporting theming and fluent-style configuration.
public final class FLabel: BaseLabel, FComponent, FCalligraphiable, FThemableForeground, FContentAvailable {
    /// A closure for performing additional custom setup on the label.
    public var customConfiguration: ((FLabel) -> Void)?
    
    /// Initializes a label with a string.
    /// - Parameter text: The string to display.
    public init(
        _ text: String
    ) {
        super.init(frame: .zero)
        self.text = text
    }
    
    /// Initializes a label with attributed text.
    /// - Parameter attributedText: The attributed string to display.
    public init(_ attributedText: NSAttributedString) {
        super.init(frame: .zero)
        self.attributedText = attributedText
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configuration?.didMoveToSuperview(superview, with: self)
        customConfiguration?(self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
    }
    
    /// Sets the text alignment of the label.
    /// - Parameter alignment: The desired text alignment.
    /// - Returns: Self for fluent chaining.
    @discardableResult public func textAlignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }
    
    /// Sets the maximum number of lines for the label.
    /// - Parameter lineLimit: The maximum number of lines (default is 1).
    /// - Returns: Self for fluent chaining.
    @discardableResult public func lineLimit(_ lineLimit: Int = 1) -> Self {
        self.numberOfLines = lineLimit
        return self
    }
    
    /// Sets the font of the label.
    /// - Parameter font: The font to use.
    /// - Returns: Self for fluent chaining.
    @discardableResult public func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    /// Sets the text color of the label.
    /// - Parameter color: The color to use (default is `.label`).
    /// - Returns: Self for fluent chaining.
    @discardableResult public func foreground(_ color: UIColor = .label) -> Self {
        self.textColor = color
        return self
    }
    
    /// The theme key for the label's foreground color.
    public var foregroundKey: ThemeKey?
    public override func apply(theme: ThemeProvider) {
        super.apply(theme: theme)
        guard let foregroundKey else { return }
        foreground(theme.color(key: foregroundKey))
    }
}
