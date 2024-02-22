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
    public var text: String = ""
    public var attributedText: NSAttributedString?
    public var font: UIFont = FontSystem.shared.font(with: .body)
    public var color: UIColor = .label
    public var lineLimit: Int = 1
    public var textAlignment: NSTextAlignment = .left
    public var contentHuggingV: UILayoutPriority = .defaultLow
    public var contentHuggingH: UILayoutPriority = .defaultLow
    public var compressionResistanceV: UILayoutPriority = .defaultHigh
    public var compressionResistanceH: UILayoutPriority = .defaultHigh
    
    public var customConfiguration: ((UILabel, FLabel) -> UILabel)?
    
    public init(
        _ text: String
    ) {
        self.text = text
        super.init(frame: .zero)
    }
    
    public init(_ attributedText: NSAttributedString) {
        self.attributedText = attributedText
        super.init(frame: .zero)
    }

    @discardableResult
    public override func rendered() -> UILabel {
        var view = UILabel()
        view.text = text
        view.font = font
        if let attributedText = attributedText {
            view.attributedText = attributedText
        }
        view.textAlignment = textAlignment
        view.textColor = color
        view.numberOfLines = lineLimit
        view.setContentCompressionResistancePriority(compressionResistanceH, for: .horizontal)
        view.setContentCompressionResistancePriority(compressionResistanceV, for: .vertical)
        view.setContentHuggingPriority(contentHuggingH, for: .horizontal)
        view.setContentHuggingPriority(contentHuggingV, for: .vertical)
        backgroundColor = contentBackgroundColor
        view = customConfiguration?(view, self) ?? view
        content = view
        return view
    }
    
    func textAlignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }
}

public extension FLabel {
    func font(_ font: UIFont = FontSystem.shared.font(with: .body)) -> Self {
        with(\.font, setTo: font)
    }

    func foreground(_ color: UIColor = .label) -> Self {
        with(\.color, setTo: color)
    }

    func lineLimit(_ lineLimit: Int = 1) -> Self {
        with(\.lineLimit, setTo: lineLimit)
    }
    
    func huggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
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
    
    func compressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
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
