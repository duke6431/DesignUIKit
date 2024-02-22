//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore
import SnapKit

public final class FLabel: FBase<UILabel>, FComponent {
    private var _text: String = ""
    private var _attributedText: NSAttributedString?
    private var _font: UIFont = FontSystem.shared.font(with: .body)
    private var _color: UIColor = .label
    private var _lineLimit: Int = 1
    private var _textAlignment: NSTextAlignment = .left
    public var contentHuggingV: UILayoutPriority = .defaultLow
    public var contentHuggingH: UILayoutPriority = .defaultLow
    public var compressionResistanceV: UILayoutPriority = .defaultHigh
    public var compressionResistanceH: UILayoutPriority = .defaultHigh
    
    public var customConfiguration: ((UILabel, FLabel) -> UILabel)?
    
    public init(
        _ text: String
    ) {
        self._text = text
        super.init(frame: .zero)
    }
    
    public init(_ attributedText: NSAttributedString) {
        self._attributedText = attributedText
        super.init(frame: .zero)
    }

    @discardableResult
    public override func rendered() -> UILabel {
        var view = UILabel()
        view.text = _text
        view.font = _font
        view.textAlignment = _textAlignment
        view.textColor = _color
        view.numberOfLines = _lineLimit
        if let attributedText = _attributedText {
            view.attributedText = attributedText
        }
        view.setContentCompressionResistancePriority(compressionResistanceH, for: .horizontal)
        view.setContentCompressionResistancePriority(compressionResistanceV, for: .vertical)
        view.setContentHuggingPriority(contentHuggingH, for: .horizontal)
        view.setContentHuggingPriority(contentHuggingV, for: .vertical)
        backgroundColor = contentBackgroundColor
        view = customConfiguration?(view, self) ?? view
        content = view
        return view
    }
    
    public func textAlignment(_ alignment: NSTextAlignment) -> Self {
        with(\._textAlignment, setTo: alignment)
    }

    public func font(_ font: UIFont = FontSystem.shared.font(with: .body)) -> Self {
        with(\._font, setTo: font)
    }

    public func foreground(_ color: UIColor = .label) -> Self {
        with(\._color, setTo: color)
    }

    public func lineLimit(_ lineLimit: Int = 1) -> Self {
        with(\._lineLimit, setTo: lineLimit)
    }
    
    public func huggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        switch axis {
        case .horizontal:
            contentHuggingH = priority
        case .vertical:
            contentHuggingV = priority
        @unknown default:
            break
        }
        return self
    }
    
    public func compressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        switch axis {
        case .horizontal:
            compressionResistanceH = priority
        case .vertical:
            compressionResistanceV = priority
        @unknown default:
            break
        }
        return self
    }
}
