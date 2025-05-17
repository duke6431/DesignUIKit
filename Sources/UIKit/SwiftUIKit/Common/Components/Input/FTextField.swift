//
//  FTextField.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2024/02/11.
//
//  A customizable and theme-aware text field that supports placeholder styling,
//  text change and submit callbacks, and fluent interface modifiers.
//

import UIKit
import DesignCore

/// A customizable and theme-aware text field that supports styled placeholders,
/// text change and submit callbacks, and theme integration.
public final class FTextField: BaseTextField, FComponent, FCalligraphiable, FThemableForeground, FThemablePlaceholder {
    /// A closure to perform additional custom configuration.
    public var customConfiguration: ((FTextField) -> Void)?
    
    /// A closure triggered when the return key is pressed.
    fileprivate var onSubmitAction: (() -> Void)?
    
    /// A closure triggered when the text changes.
    fileprivate var onChangeAction: ((String) -> Void)?
    
    /// The underlying placeholder text shown using a CATextLayer.
    public var customPlaceholder: String = "" {
        didSet {
            textLayer.string = customPlaceholder
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
    public override var font: UIFont? {
        didSet {
            if let font = self.font {
                textLayer.font = font
            } else {
                textLayer.fontSize = 17.0
            }
        }
    }
    public override var textAlignment: NSTextAlignment {
        didSet {
            textLayer.alignmentMode = textAlignment.caMode
        }
    }
    
    private let textLayer = CCATextLayer()
    
    /// Initializes the text field with a placeholder and initial text.
    /// - Parameters:
    ///   - placeholder: The placeholder string.
    ///   - text: The initial text.
    public init(
        _ placeholder: String,
        _ text: String
    ) {
        super.init(frame: .zero)
        self.text = text
        self.customPlaceholder = placeholder
        preconditions()
    }
    
    /// Initializes the text field with attributed text.
    /// - Parameter attributedText: The attributed string to display.
    public init(_ attributedText: NSAttributedString) {
        super.init(frame: .zero)
        self.attributedText = attributedText
        preconditions()
    }
    
    /// Sets up the placeholder layer and layout on initialization.
    public func preconditions() {
        textLayer.string = customPlaceholder
        preparePlaceholder()
        setNeedsLayout()
    }
    
    /// Configures the placeholder CATextLayer and inserts it into the layer hierarchy.
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
    
    /// Handles additional setup when added to a superview.
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configuration?.didMoveToSuperview(superview, with: self)
        customConfiguration?(self)
        addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    /// Cleans up target-actions when removed from the superview.
    public override func removeFromSuperview() {
        super.removeFromSuperview()
        removeTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    /// Lays out subviews and updates the placeholder layer frame.
    public override func layoutSubviews() {
        super.layoutSubviews()
        textLayer.frame = textRect(forBounds: bounds)
        configuration?.updateLayers(for: self)
    }
    
    /// Sets the placeholder text.
    @discardableResult public func placeholder(_ placeholder: String?) -> Self {
        self.customPlaceholder = placeholder ?? ""
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
    
    /// Registers a closure to call when the text changes.
    @discardableResult public func onChange(_ onChange: ((String) -> Void)? = nil) -> Self {
        self.onChangeAction = onChange
        return self
    }
    
    /// Registers a closure to call when the return key is pressed.
    @discardableResult public func onSubmit(_ onSubmit: (() -> Void)? = nil) -> Self {
        self.onSubmitAction = onSubmit
        return self
    }
    
    public var foregroundKey: ThemeKey?
    public var placeholderKey: ThemeKey?
    
    /// Applies theme-based colors for text and placeholder using the assigned keys.
    public override func apply(theme: ThemeProvider) {
        super.apply(theme: theme)
        if let foregroundKey { foreground(theme.color(key: foregroundKey)) }
        if let placeholderKey { placeholder(theme.color(key: placeholderKey)) }
    }
}

/// Handles UITextFieldDelegate methods for return key and text change monitoring.
extension FTextField: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        UIView.animate(withDuration: 0.15) { [textLayer] in
            textLayer.opacity = textField.text?.isEmpty ?? true ? 1.0 : 0.0
        }
        onChangeAction?(textField.text ?? "")
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onSubmitAction?()
        textField.endEditing(true)
        return true
    }
}

/// Converts a `NSTextAlignment` to the corresponding `CATextLayerAlignmentMode`.
extension NSTextAlignment {
    var caMode: CATextLayerAlignmentMode {
        switch self {
        case .left:
            return .left
        case .center:
            return .center
        case .right:
            return .right
        case .justified:
            return .justified
        case .natural:
            return .natural
        @unknown default:
            return .left
        }
    }
}
