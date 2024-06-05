//
//  File.swift
//
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif
import DesignCore
import SnapKit
import Combine

public final class FTextField: BaseTextField, FComponent, FStylable, FThemableForeground, FThemablePlaceholder {
    public var customConfiguration: ((FTextField) -> Void)?
    fileprivate var onSubmitAction: (() -> Void)?
    fileprivate var onChangeAction: ((String) -> Void)?

    private let textLayer = CCATextLayer()
    public var customPlaceholder: String = "" {
        didSet {
            textLayer.string = customPlaceholder
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
    public override var textAlignment: NSTextAlignment {
        didSet {
            textLayer.alignmentMode = textAlignment.caMode
        }
    }

    public init(
        _ placeholder: String,
        _ text: String
    ) {
        super.init(frame: .zero)
        self.text = text
        self.customPlaceholder = placeholder
        preconditions()
    }
    
    public init(
        _ placeholder: String,
        _ textPublisher: FBinder<String>
    ) {
        super.init(frame: .zero)
        self.customPlaceholder = placeholder
        self.bind(to: textPublisher) { field, text in field.text = text }
        preconditions()
    }
    
    public init(_ attributedText: NSAttributedString) {
        super.init(frame: .zero)
        self.attributedText = attributedText
        preconditions()
    }
    
    public func preconditions() {
        textLayer.string = customPlaceholder
        preparePlaceholder()
        setNeedsLayout()
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
        addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    public override func removeFromSuperview() {
        super.removeFromSuperview()
        removeTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        textLayer.frame = textRect(forBounds: bounds)
        configuration?.updateLayers(for: self)
    }

    @discardableResult public func placeholder(_ placeholder: String?) -> Self {
        self.customPlaceholder = placeholder ?? ""
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
}

#if canImport(UIKit)
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
#else
extension FTextField {
    public override func textDidChange(_ notification: Notification) {
        UIView.animate(withDuration: 0.15) { [textLayer] in
            textLayer.opacity = textField.text?.isEmpty ?? true ? 1.0 : 0.0
        }
        onChangeAction?(text)
    }
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        onChangeAction?(textField.text ?? "")
//    }
//    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        onSubmitAction?()
//        textField.endEditing(true)
//        return true
//    }
}
#endif

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
