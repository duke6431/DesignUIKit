//
//  FButton.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore
import SnapKit

public class FButton: FBase<UIButton>, FViewable {
    public var text: String = ""
    public var image: String = ""
    public var font: UIFont = FontSystem.shared.font(with: .body)
    public var color: UIColor = .systemBlue
    public var contentHuggingV: UILayoutPriority = .defaultLow
    public var contentHuggingH: UILayoutPriority = .defaultLow
    public var compressionResistanceV: UILayoutPriority = .defaultHigh
    public var compressionResistanceH: UILayoutPriority = .defaultHigh
    public var labels: [UIView]?
    public var action: (() -> Void)?
    
    public var customConfiguration: ((UIButton, FButton) -> UIButton)?
    
    public init(
        text: String = "", image: String = "",
        font: UIFont = FontSystem.shared.font(with: .body), color: UIColor = .systemBlue,
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
        super.init(frame: .zero)
    }

    public init(@FBuilder<UIView> label: () -> [UIView], action: (() -> Void)? = nil, customConfiguration: ((UIButton, FButton) -> UIButton)? = nil) {
        self.labels = label()
        self.action = action
        self.customConfiguration = customConfiguration
        super.init(frame: .zero)
    }
    
    @discardableResult
    public override func rendered() -> UIButton {
        let view = DimmingButton(type: .custom)
        if let labels {
            labels.forEach { label in
                view.addSubview(label)
                label.isUserInteractionEnabled = false
                if label as? (any FViewable & UIView) == nil {
                    label.snp.makeConstraints {
                        $0.edges.equalToSuperview()
                    }
                }
            }
        } else {
            view.setTitle(text, for: .normal)
            view.titleLabel?.font = font
            view.setTitleColor(color, for: .normal)
        }
        view.setContentCompressionResistancePriority(compressionResistanceH, for: .horizontal)
        view.setContentCompressionResistancePriority(compressionResistanceV, for: .vertical)
        view.setContentHuggingPriority(contentHuggingH, for: .horizontal)
        view.setContentHuggingPriority(contentHuggingV, for: .vertical)
        if let action = action { view.addAction(for: .touchUpInside, action) }
        backgroundColor = contentBackgroundColor
        let final = customConfiguration?(view, self) ?? view
        content = final
        return final
    }
}
