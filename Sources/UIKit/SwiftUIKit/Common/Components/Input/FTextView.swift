//
//  FTextView.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2024/05/16.
//
//  A customizable and theme-aware text view that supports styled placeholders,
//  text change and submit callbacks, and fluent configuration modifiers.
//

import DesignCore
import QuartzCore
import UIKit

/// A customizable and theme-aware text view that supports styled placeholders,
/// text change and submit callbacks, and fluent configuration modifiers.
public final class FTextView: BaseTextView, FComponent, FCalligraphiable, FThemableForeground, FThemablePlaceholder {
    /// Closure for performing additional custom configuration.
    public var customConfiguration: ((FTextView) -> Void)?
    
    /// Closure called when the return key is pressed.
    fileprivate var onSubmitAction: (() -> Void)?
    
    /// Closure called when the text changes.
    fileprivate var onChangeAction: ((String) -> Void)?
    
    /// A layer used to render the placeholder text.
    private let textLayer = CATextLayer()
    
    /// The placeholder string displayed when the text view is empty.
    public var placeholder: String = "" {
        didSet {
            textLayer.string = placeholder
            setNeedsLayout()
        }
    }
    
    /// The color used for the placeholder text.
    public var placeholderColor: UIColor = .lightGray {
        didSet {
            textLayer.foregroundColor = placeholderColor.cgColor
            setNeedsLayout()
        }
    }
    
    /// Overrides the font and synchronizes the font size with the placeholder layer.
    public override var font: UIFont? {
        didSet {
            if let font = self.font {
                textLayer.font = font
            } else {
                textLayer.fontSize = 17.0
            }
        }
    }
    
    /// Initializes a new `FTextView` with a placeholder and initial text.
    /// - Parameters:
    ///   - placeholder: The placeholder text.
    ///   - text: The initial text content.
    public convenience init(
        _ placeholder: String,
        _ text: String
    ) {
        self.init(frame: .zero)
        self.text = text
        self.placeholder = placeholder
        preconditions()
    }
    
    /// Sets up the placeholder text layer and layout configuration.
    public func preconditions() {
        textLayer.string = placeholder
        removeTextContainerInsets()
        preparePlaceholder()
        setNeedsLayout()
    }
    
    /// Removes default padding from the text container to enable custom layout control.
    func removeTextContainerInsets() {
        textContainer.lineFragmentPadding = 0
        textContainerInset = .zero
    }
    
    /// Prepares the CATextLayer used for displaying the placeholder.
    func preparePlaceholder() {
        // textLayer properties
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.alignmentMode = .left
        textLayer.isWrapped = true
        textLayer.foregroundColor = placeholderColor.cgColor
        
        if let font = self.font {
            textLayer.fontSize = font.pointSize
        } else {
            textLayer.fontSize = 17.0
        }
        
        // insert the textLayer
        layer.insertSublayer(textLayer, at: 0)
        
        // set delegate to self
        delegate = self
    }
    
    /// Handles configuration and custom setup when added to a superview.
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configuration?.didMoveToSuperview(superview, with: self)
        customConfiguration?(self)
    }
    
    /// Lays out subviews and updates the placeholder layer frame.
    public override func layoutSubviews() {
        super.layoutSubviews()
        textLayer.frame = bounds.insetBy(
            dx: textContainerInset.left + textContainer.lineFragmentPadding,
            dy: textContainerInset.top
        )
        configuration?.updateLayers(for: self)
    }
    
    /// Sets the placeholder string.
    @discardableResult public func placeholder(_ placeholder: String?) -> Self {
        self.placeholder = placeholder ?? ""
        return self
    }
    
    /// Sets the text alignment.
    @discardableResult public func textAlignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }
    
    /// Sets the font.
    @discardableResult public func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    /// Sets the text color.
    @discardableResult public func foreground(_ color: UIColor = .label) -> Self {
        self.textColor = color
        return self
    }
    
    /// Sets the placeholder color.
    @discardableResult public func placeholder(_ color: UIColor = .secondaryLabel) -> Self {
        self.placeholderColor = color
        return self
    }
    
    /// Sets the callback for text changes.
    @discardableResult public func onChange(_ onChange: ((String) -> Void)? = nil) -> Self {
        self.onChangeAction = onChange
        return self
    }
    
    /// Sets the callback for the return key (submit).
    @discardableResult public func onSubmit(_ onSubmit: (() -> Void)? = nil) -> Self {
        self.onSubmitAction = onSubmit
        return self
    }
    
    public var foregroundKey: ThemeKey?
    public var placeholderKey: ThemeKey?
    
    /// Applies themed colors to the text and placeholder using the configured theme keys.
    public override func apply(theme: ThemeProvider) {
        super.apply(theme: theme)
        if let foregroundKey { foreground(theme.color(key: foregroundKey)) }
        if let placeholderKey { placeholder(theme.color(key: placeholderKey)) }
    }
    
    /// Handles live text changes and updates the placeholder layer opacity accordingly.
    /// - Parameter textView: The text view whose text changed.
    @objc dynamic public func textViewDidChange(_ textView: UITextView) {
        UIView.animate(withDuration: 0.15) { [textLayer] in
            textLayer.opacity = textView.text.isEmpty ? 1.0 : 0.0
        }
        onChangeAction?(textView.text ?? "")
    }
}

/// Conforms to `UITextViewDelegate` to enable live text monitoring.
extension FTextView: UITextViewDelegate { }
