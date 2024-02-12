//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore

public class FLabel: FViewable {
    public var text: String
    public var attributedText: NSAttributedString?
    public var font: UIFont
    public var color: UIColor
    public var numberOfLine: Int
    public var contentHuggingV: UILayoutPriority
    public var contentHuggingH: UILayoutPriority
    public var compressionResistanceV: UILayoutPriority
    public var compressionResistanceH: UILayoutPriority
    public var customConfiguration: ((UILabel, FLabel) -> UILabel)?
    
    public init(
        text: String = "", attributedText: NSAttributedString? = nil,
        font: UIFont = FontSystem.shared.font(with: .body), color: UIColor = .label,
        numberOfLine: Int = 3,
        contentHuggingV: UILayoutPriority = .defaultLow, contentHuggingH: UILayoutPriority = .defaultLow,
        compressionResistanceV: UILayoutPriority = .defaultHigh, compressionResistanceH: UILayoutPriority = .defaultHigh,
        customConfiguration: ((UILabel, FLabel) -> UILabel)? = nil
    ) {
        self.text = text
        self.font = font
        self.color = color
        self.attributedText = attributedText
        self.numberOfLine = numberOfLine
        self.contentHuggingV = contentHuggingV
        self.contentHuggingH = contentHuggingH
        self.compressionResistanceV = compressionResistanceV
        self.compressionResistanceH = compressionResistanceH
        self.customConfiguration = customConfiguration
    }
    
    public func rendered() -> UILabel {
        let view = UILabel()
        view.text = text
        view.font = font
        if let attributedText = attributedText {
            view.attributedText = attributedText
        }
        view.clipsToBounds = true
        view.textColor = color
        view.numberOfLines = numberOfLine
        view.setContentCompressionResistancePriority(compressionResistanceH, for: .horizontal)
        view.setContentCompressionResistancePriority(compressionResistanceV, for: .vertical)
        view.setContentHuggingPriority(contentHuggingH, for: .horizontal)
        view.setContentHuggingPriority(contentHuggingV, for: .vertical)
        return customConfiguration?(view, self) ?? view
    }
}
