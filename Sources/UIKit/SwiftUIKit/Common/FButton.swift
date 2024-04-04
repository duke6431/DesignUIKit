//
//  FButton.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif
import Combine
import DesignCore
import SnapKit

public class FButton: BaseButton, FConfigurable, FComponent, FStylable, FThemableForeground, FContentConstraintable {
    public var customConfiguration: ((FButton) -> Void)?
    
    public convenience init(
        style: BButton.ButtonType? = nil,
        _ textPublisher: FBinder<String>,
        action: @escaping () -> Void
    ) {
        self.init(style: style)
        self.bind(to: textPublisher) { button, title in
#if canImport(UIKit)
            button.setTitle(title, for: .normal)
#else
            button.title = title
#endif
        }
        addAction(for: .touchUpInside, action)
    }
    
    public convenience init(
        style: BButton.ButtonType? = nil,
        _ text: String = "",
        action: @escaping () -> Void
    ) {
        self.init(style: style)
#if canImport(UIKit)
            setTitle(text, for: .normal)
#else
            title = text
#endif
        addAction(for: .touchUpInside, action)
    }

    public convenience init(style: BButton.ButtonType? = nil, @FViewBuilder label: () -> FBody, action: @escaping () -> Void) {
        self.init(style: style)
        addAction(for: .touchUpInside, action)
        label().forEach { label in
            addSubview(label)
            label.isUserInteractionEnabled = false
            if label as? (any FComponent & UIView) == nil {
                label.snp.remakeConstraints {
                    $0.edges.equalToSuperview()
                }
            }
        }
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
    
    @discardableResult public func font(_ font: BFont = FontSystem.shared.font(with: .body)) -> Self {
        titleLabel?.with(\.font, setTo: font)
        return self
    }

    @discardableResult public func foreground(_ color: BColor = .label) -> Self {
        setTitleColor(color, for: .normal)
        return self
    }
    
    public var foregroundKey: ThemeKey?
    public override func apply(theme: ThemeProvider) {
        super.apply(theme: theme)
        guard let foregroundKey else { return }
        foreground(theme.color(key: foregroundKey))
    }
}
