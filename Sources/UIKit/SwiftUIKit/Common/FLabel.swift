//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore
import SnapKit

public final class FLabel: FBase<UILabel>, FViewable {
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
        text: String = "", attributedText: NSAttributedString? = nil,
        font: UIFont = FontSystem.shared.font(with: .body), color: UIColor = .label,
        lineLimit: Int = 1,
        contentHuggingV: UILayoutPriority = .defaultLow, contentHuggingH: UILayoutPriority = .defaultLow,
        compressionResistanceV: UILayoutPriority = .defaultHigh, compressionResistanceH: UILayoutPriority = .defaultHigh,
        customConfiguration: ((UILabel, FLabel) -> UILabel)? = nil
    ) {
        self.text = text
        self.font = font
        self.color = color
        self.attributedText = attributedText
        self.lineLimit = lineLimit
        self.contentHuggingV = contentHuggingV
        self.contentHuggingH = contentHuggingH
        self.compressionResistanceV = compressionResistanceV
        self.compressionResistanceH = compressionResistanceH
        self.customConfiguration = customConfiguration
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
