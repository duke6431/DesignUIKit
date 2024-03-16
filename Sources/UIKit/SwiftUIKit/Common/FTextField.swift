//
//  File.swift
//
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore
import SnapKit
import Combine

public final class FTextField: BaseTextField, FConfigurable, FComponent, FStylable {
    public var customConfiguration: ((FTextField) -> Void)?
    fileprivate var onSubmitAction: (() -> Void)?
    
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
        customConfiguration?(self)
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

    @discardableResult public func font(_ font: UIFont = FontSystem.shared.font(with: .body)) -> Self {
        self.font = font
        return self
    }

    @discardableResult public func foreground(_ color: UIColor = .label) -> Self {
        self.textColor = color
        return self
    }
    
    @discardableResult public func onSubmit(_ onSubmit: (() -> Void)? = nil) -> Self {
        self.onSubmitAction = onSubmit
        return self
    }
}

extension FTextField: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onSubmitAction?()
        return true
    }
}
