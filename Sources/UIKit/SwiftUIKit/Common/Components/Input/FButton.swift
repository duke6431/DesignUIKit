//
//  FButton.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore
import SnapKit

public final class FButton: BaseButton, FComponent, FCalligraphiable, FThemableForeground, FContentConstraintable, FAssignable {
    public var customConfiguration: ((FButton) -> Void)?
    
    var label: FBody?
    
    public convenience init(
        style: UIButton.ButtonType? = nil,
        _ text: String = "",
        action: @escaping () -> Void
    ) {
        self.init(style: style)
        setTitle(text, for: .normal)
        addAction(for: .touchUpInside, action)
    }

    public convenience init(style: UIButton.ButtonType? = nil, @FViewBuilder label: () -> FBody, action: @escaping () -> Void) {
        self.init(style: style)
        addAction(for: .touchUpInside, action)
        self.label = label().flatMap {
            ($0 as? FForEach)?.content() ?? [$0]
        }
    }

    public convenience init(
        style: UIButton.ButtonType? = nil,
        _ text: String = "",
        action: @escaping (FButton?) -> Void
    ) {
        self.init(style: style)
        setTitle(text, for: .normal)
        addAction(for: .touchUpInside, { [weak self] in action(self) })
    }

    public convenience init(style: UIButton.ButtonType? = nil, @FViewBuilder label: () -> FBody, action: @escaping (FButton?) -> Void) {
        self.init(style: style)
        addAction(for: .touchUpInside, { [weak self] in action(self) })
        self.label = label().flatMap {
            ($0 as? FForEach)?.content() ?? [$0]
        }
    }
    
    func updateLabel() {
        label?.forEach { label in
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
        updateLabel()
        configuration?.didMoveToSuperview(superview, with: self)
        customConfiguration?(self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
    }

    @discardableResult public func font(_ font: UIFont) -> Self {
        titleLabel?.with(\.font, setTo: font)
        return self
    }

    @discardableResult public func foreground(_ color: UIColor) -> Self {
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
