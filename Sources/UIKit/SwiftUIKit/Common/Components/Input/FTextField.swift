//
//  File.swift
//
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore

public class FTextField: BaseTextField, FComponent, FCalligraphiable, FThemableForeground, FThemablePlaceholder {
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

    public init(
        _ placeholder: String,
        _ text: String
    ) {
        super.init(frame: .zero)
        self.text = text
        self.customPlaceholder = placeholder
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
}

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
