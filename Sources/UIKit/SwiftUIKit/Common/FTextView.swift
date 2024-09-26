//
//  FTextView.swift
//  
//
//  Created by Duc Minh Nguyen on 5/16/24.
//

import Combine
import DesignCore
import SnapKit
import QuartzCore
import UIKit

open class FTextView: BaseTextView, FComponent, FStylable, FThemableForeground, FThemablePlaceholder {
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
    public var placeholderColor: BColor = .lightGray {
        didSet {
            textLayer.foregroundColor = placeholderColor.cgColor
            setNeedsLayout()
        }
    }
    public override var font: BFont? {
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
    
    public convenience init(
        _ placeholder: String,
        _ textPublisher: FBinder<String>
    ) {
        self.init(frame: .zero)
        self.placeholder = placeholder
        self.bind(to: textPublisher) { field, text in field.text = text }
        preconditions()
    }
    
    open func preconditions() {
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

    @discardableResult public func font(_ font: BFont = FontSystem.shared.font(with: .body)) -> Self {
        self.font = font
        return self
    }

    @discardableResult public func foreground(_ color: BColor = .label) -> Self {
        self.textColor = color
        return self
    }
    
    @discardableResult public func placeholder(_ color: BColor = .secondaryLabel) -> Self {
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
    
#if canImport(UIKit)
    @objc dynamic open func textViewDidChange(_ textView: UITextView) {
        UIView.animate(withDuration: 0.15) { [textLayer] in
            textLayer.opacity = textView.text.isEmpty ? 1.0 : 0.0
        }
        onChangeAction?(textView.text ?? "")
    }
#else
    @objc dynamic open override func textDidChange(_ notification: Notification) {
        onChangeAction?(text)
    }
#endif
}

#if canImport(UIKit)
extension FTextView: UITextViewDelegate { }
#endif
