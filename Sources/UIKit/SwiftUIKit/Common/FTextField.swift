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

public final class FTextField: BaseTextField, FComponent, FStylable, FThemableForeground {
    public var layoutConfiguration: ((ConstraintMaker) -> Void)?
    public var customConfiguration: ((FTextField) -> Void)?
    fileprivate var onSubmitAction: (() -> Void)?
    fileprivate var onChangeAction: ((String) -> Void)?
    
    public init(
        _ placeholder: String,
        _ text: String
    ) {
        super.init(frame: .zero)
        self.text = text
        self.placeholder = placeholder
    }
    
    public init(
        _ placeholder: String,
        _ textPublisher: FBinder<String>
    ) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.bind(to: textPublisher) { field, text in field.text = text }
    }
    
    public init(_ attributedText: NSAttributedString) {
        super.init(frame: .zero)
        self.attributedText = attributedText
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        delegate = self
        configuration?.didMoveToSuperview(superview, with: self)
        if let layoutConfiguration, superview != nil {
            snp.makeConstraints(layoutConfiguration)
        }
        customConfiguration?(self)
        addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    public override func removeFromSuperview() {
        super.removeFromSuperview()
        removeTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
    }

    @discardableResult public func placeholder(_ placeholder: String?) -> Self {
        self.placeholder = placeholder
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
    
    @discardableResult public func onChange(_ onChange: ((String) -> Void)? = nil) -> Self {
        self.onChangeAction = onChange
        return self
    }
    
    @discardableResult public func onSubmit(_ onSubmit: (() -> Void)? = nil) -> Self {
        self.onSubmitAction = onSubmit
        return self
    }
    
    public var foregroundKey: ThemeKey?
    public override func apply(theme: ThemeProvider) {
        super.apply(theme: theme)
        guard let foregroundKey else { return }
        foreground(theme.color(key: foregroundKey))
    }
}

#if canImport(UIKit)
extension FTextField: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
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
