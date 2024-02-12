//
//  FButton.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore

public class FButton: FViewable {
    public var text: String
    public var image: String
    public var font: UIFont
    public var color: UIColor
    public var contentHuggingV: UILayoutPriority
    public var contentHuggingH: UILayoutPriority
    public var compressionResistanceV: UILayoutPriority
    public var compressionResistanceH: UILayoutPriority
    public var action: (() -> Void)?
    public var customConfiguration: ((UIButton, FButton) -> UIButton)?
    
    public init(
        text: String = "", image: String = "",
        font: UIFont = FontSystem.shared.font(with: .body), color: UIColor = .label,
        contentHuggingV: UILayoutPriority = .defaultLow, contentHuggingH: UILayoutPriority = .defaultLow,
        compressionResistanceV: UILayoutPriority = .defaultHigh, compressionResistanceH: UILayoutPriority = .defaultHigh,
        action: (() -> Void)? = nil,
        customConfiguration: ((UIButton, FButton) -> UIButton)? = nil
    ) {
        self.text = text
        self.image = image
        self.font = font
        self.color = color
        self.contentHuggingV = contentHuggingV
        self.contentHuggingH = contentHuggingH
        self.compressionResistanceV = compressionResistanceV
        self.compressionResistanceH = compressionResistanceH
        self.action = action
        self.customConfiguration = customConfiguration
    }
    
    public func rendered() -> UIButton {
        let view = UIButton()
        view.setTitle(text, for: .normal)
        view.titleLabel?.font = font
        view.clipsToBounds = true
        view.setTitleColor(color, for: .normal)
        view.setContentCompressionResistancePriority(compressionResistanceH, for: .horizontal)
        view.setContentCompressionResistancePriority(compressionResistanceV, for: .vertical)
        view.setContentHuggingPriority(contentHuggingH, for: .horizontal)
        view.setContentHuggingPriority(contentHuggingV, for: .vertical)
        if let action = action { view.addAction(for: .touchUpInside, action) }
        return customConfiguration?(view, self) ?? view
    }
}
