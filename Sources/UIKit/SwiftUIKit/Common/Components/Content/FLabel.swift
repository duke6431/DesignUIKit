//
//  File.swift
//
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore

public final class FLabel: BaseLabel, FComponent, FCalligraphiable, FThemableForeground, FContentAvailable {
    public var customConfiguration: ((FLabel) -> Void)?

    public init(
        _ text: String
    ) {
        super.init(frame: .zero)
        self.text = text
    }

    public init(_ attributedText: NSAttributedString) {
        super.init(frame: .zero)
        self.attributedText = attributedText
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configuration?.didMoveToSuperview(superview, with: self)
        customConfiguration?(self)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
    }

    @discardableResult public func textAlignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }

    @discardableResult public func lineLimit(_ lineLimit: Int = 1) -> Self {
        self.numberOfLines = lineLimit
        return self
    }

    @discardableResult public func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }

    @discardableResult public func foreground(_ color: UIColor = .label) -> Self {
        self.textColor = color
        return self
    }

    public var foregroundKey: ThemeKey?
    public override func apply(theme: ThemeProvider) {
        super.apply(theme: theme)
        guard let foregroundKey else { return }
        foreground(theme.color(key: foregroundKey))
    }
}
