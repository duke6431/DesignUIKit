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
    
    public init(
        _ text: String
    ) {
        super.init(frame: .zero)
        self.text = text
    }
    
    public init(
        _ textPublisher: FBinder<String>
    ) {
        super.init(frame: .zero)
        self.bind(to: textPublisher) { label, text in label.text = text }
    }
    
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
}
