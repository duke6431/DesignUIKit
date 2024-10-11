//
//  FTextView.swift
//  
//
//  Created by Duc Minh Nguyen on 5/16/24.
//

import DesignCore
import QuartzCore
import UIKit

public final class FTextView: BaseTextView, FComponent, FCalligraphiable, FThemableForeground, FThemablePlaceholder, FAssignable {
    public var customConfiguration: ((FTextView) -> Void)?
    fileprivate var onSubmitAction: (() -> Void)?
    fileprivate var onChangeAction: ((String) -> Void)?
    
    private let textLayer = CATextLayer()
    
    public var placeholder: String = "" {
        didSet {
            textLayer.string = placeholder
            setNeedsLayout()
        }
    }
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

    public convenience init(
        _ placeholder: String,
        _ text: String
    ) {
        self.init(frame: .zero)
        self.text = text
        self.placeholder = placeholder
        preconditions()
    }
    
    public func preconditions() {
        textLayer.string = placeholder
        removeTextContainerInsets()
        preparePlaceholder()
        setNeedsLayout()
    }
    
    func removeTextContainerInsets() {
        textContainer.lineFragmentPadding = 0
        textContainerInset = .zero
    }
    
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
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configuration?.didMoveToSuperview(superview, with: self)
        customConfiguration?(self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        textLayer.frame = bounds.insetBy(
            dx: textContainerInset.left + textContainer.lineFragmentPadding,
            dy: textContainerInset.top
        )
        configuration?.updateLayers(for: self)
    }

    @discardableResult public func placeholder(_ placeholder: String?) -> Self {
        self.placeholder = placeholder ?? ""
        return self
    }
    
    @discardableResult public func textAlignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }

    @discardableResult public func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }

    @discardableResult public func foreground(_ color: UIColor = .label) -> Self {
        self.textColor = color
        return self
    }
    
    @discardableResult public func placeholder(_ color: UIColor = .secondaryLabel) -> Self {
        self.placeholderColor = color
        return self
    }
    
    @discardableResult public func onChange(_ onChange: ((String) -> Void)? = nil) -> Self {
        self.onChangeAction = onChange
        return self
    }
    
    @discardableResult public func onSubmit(_ onSubmit: (() -> Void)? = nil) -> Self {
        self.onSubmitAction = onSubmit
        return self
    }
    
    public var foregroundKey: ThemeKey?
    public var placeholderKey: ThemeKey?
    public override func apply(theme: ThemeProvider) {
        super.apply(theme: theme)
        if let foregroundKey { foreground(theme.color(key: foregroundKey)) }
        if let placeholderKey { placeholder(theme.color(key: placeholderKey)) }
    }
    
    @objc dynamic public func textViewDidChange(_ textView: UITextView) {
        UIView.animate(withDuration: 0.15) { [textLayer] in
            textLayer.opacity = textView.text.isEmpty ? 1.0 : 0.0
        }
        onChangeAction?(textView.text ?? "")
    }
}

extension FTextView: UITextViewDelegate { }
