//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore
import SnapKit

public final class FLabel: FBase<UILabel>, FComponent, FStylable, FContentContaining {
    private var text: String = ""
    private var attributedText: NSAttributedString?
    public var font: UIFont = FontSystem.shared.font(with: .body)
    public var color: UIColor = .label
    private var lineLimit: Int = 1
    private var textAlignment: NSTextAlignment = .left
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
        view.textAlignment = textAlignment
        view.textColor = color
        view.numberOfLines = lineLimit
        if let attributedText {
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
        self.textAlignment = alignment
        return self
    }

    public func lineLimit(_ lineLimit: Int = 1) -> Self {
        self.lineLimit = lineLimit
        return self
    }
}
