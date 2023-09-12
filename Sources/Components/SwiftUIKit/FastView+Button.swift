//
//  FastView+Button.swift
//  DesignComponents
//
//  Created by Duc IT. Nguyen Minh on 12/09/2023.
//

import UIKit
import DesignCore
import DesignToolbox
import SnapKit

public extension FastView {
    struct Button: FastViewable {
        var text: String
        var font: UIFont = FontSystem.font(with: .body)
        var color: UIColor = .systemBlue
        var contentHuggingV: UILayoutPriority = .defaultLow
        var contentHuggingH: UILayoutPriority = .defaultLow
        var compressionResistanceV: UILayoutPriority = .defaultHigh
        var compressionResistanceH: UILayoutPriority = .defaultHigh
        var customConfiguration: ((UIButton) -> Void)?
        var action: (() -> Void)?

        public init(text: String, font: UIFont = FontSystem.font(with: .body), color: UIColor = .systemBlue,
                    contentHuggingV: UILayoutPriority = .defaultLow,
                    contentHuggingH: UILayoutPriority = .defaultLow,
                    compressionResistanceV: UILayoutPriority = .defaultHigh,
                    compressionResistanceH: UILayoutPriority = .defaultHigh,
                    action: (() -> Void)? = nil, customConfiguration: ((UIButton) -> Void)? = nil) {
            self.text = text
            self.font = font
            self.color = color
            self.contentHuggingV = contentHuggingV
            self.contentHuggingH = contentHuggingH
            self.compressionResistanceV = compressionResistanceV
            self.compressionResistanceH = compressionResistanceH
            self.action = action
            self.customConfiguration = customConfiguration
        }

        public func render() -> UIView {
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
            customConfiguration?(view)
            return view
        }
    }
}
