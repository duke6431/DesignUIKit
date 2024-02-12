//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore
import SnapKit

public final class FLabel: UIView, FViewable {
    public var text: String = ""
    public var attributedText: NSAttributedString?
    public var font: UIFont = FontSystem.shared.font(with: .body)
    public var color: UIColor = .label
    public var numberOfLine: Int = 1
    public var contentHuggingV: UILayoutPriority = .defaultLow
    public var contentHuggingH: UILayoutPriority = .defaultLow
    public var compressionResistanceV: UILayoutPriority = .defaultHigh
    public var compressionResistanceH: UILayoutPriority = .defaultHigh
    
    public var padding: UIEdgeInsets?
    public var customConfiguration: ((UILabel, FLabel) -> UILabel)?
    
    public private(set) weak var content: UILabel?
    
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
        super.init(frame: .zero)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func rendered() -> UILabel {
        var view = UILabel()
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
        view = customConfiguration?(view, self) ?? view
        content = view
        return view
    }
    
    public override func didMoveToSuperview() {
        addSubview(rendered())
        snp.makeConstraints {
            $0.top.equalToSuperview().inset(padding?.top ?? 0).priority(.medium)
            $0.leading.equalToSuperview().inset(padding?.left ?? 0).priority(.medium)
            $0.trailing.equalToSuperview().inset(padding?.right ?? 0).priority(.medium)
            $0.bottom.equalToSuperview().inset(padding?.bottom ?? 0).priority(.medium)
        }
    }
}
