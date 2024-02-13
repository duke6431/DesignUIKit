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
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @discardableResult
    public override func rendered() -> UIButton {
        var view = UIButton(type: .custom)
        view.setTitle(text, for: .normal)
        view.titleLabel?.font = font
        view.clipsToBounds = true
        view.setTitleColor(color, for: .normal)
        view.setContentCompressionResistancePriority(compressionResistanceH, for: .horizontal)
        view.setContentCompressionResistancePriority(compressionResistanceV, for: .vertical)
        view.setContentHuggingPriority(contentHuggingH, for: .horizontal)
        view.setContentHuggingPriority(contentHuggingV, for: .vertical)
        if let action = action { view.addAction(for: .touchUpInside, action) }
        view.backgroundColor = backgroundColor
        view = customConfiguration?(view, self) ?? view
        content = view
        return view
    }
}
