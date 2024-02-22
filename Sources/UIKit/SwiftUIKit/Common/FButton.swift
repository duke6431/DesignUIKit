//
//  FButton.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore
import SnapKit

public class FButton: FBase<UIButton>, FComponent {
    public var text: String = ""
    private var _font: UIFont = FontSystem.shared.font(with: .body)
    private var _color: UIColor = .systemBlue
    public var contentHuggingV: UILayoutPriority = .defaultLow
    public var contentHuggingH: UILayoutPriority = .defaultLow
    public var compressionResistanceV: UILayoutPriority = .defaultHigh
    public var compressionResistanceH: UILayoutPriority = .defaultHigh
    public var labels: [UIView]?
    public var action: (() -> Void)?
    
    public var customConfiguration: ((UIButton, FButton) -> UIButton)?
    
    public init(
        _ text: String = "",
        action: (() -> Void)? = nil
    ) {
        self.text = text
        self.action = action
        super.init(frame: .zero)
    }

    public init(@FViewBuilder label: () -> FBody, action: (() -> Void)? = nil) {
        self.labels = label()
        self.action = action
        super.init(frame: .zero)
    }
    
    @discardableResult
    public override func rendered() -> UIButton {
        let view = DimmingButton(type: .custom)
        if let labels {
            labels.forEach { label in
                view.addSubview(label)
                label.isUserInteractionEnabled = false
                if label as? (any FComponent & UIView) == nil {
                    label.snp.makeConstraints {
                        $0.edges.equalToSuperview()
                    }
                }
            }
        } else {
            view.setTitle(text, for: .normal)
            view.titleLabel?.font = _font
            view.setTitleColor(_color, for: .normal)
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

    public func font(_ font: UIFont = FontSystem.shared.font(with: .body)) -> Self {
        with(\._font, setTo: font)
    }

    public func foreground(_ color: UIColor = .label) -> Self {
        with(\._color, setTo: color)
    }
    
    public func huggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        switch axis {
        case .horizontal:
            contentHuggingH = priority
        case .vertical:
            contentHuggingV = priority
        @unknown default:
            break
        }
        return self
    }
    
    public func compressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        switch axis {
        case .horizontal:
            compressionResistanceH = priority
        case .vertical:
            compressionResistanceV = priority
        @unknown default:
            break
        }
        return self
    }
}
