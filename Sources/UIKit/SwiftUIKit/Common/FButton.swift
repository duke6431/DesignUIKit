//
//  FButton.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import Combine
import DesignCore
import SnapKit

public class FButton: BaseButton, FConfigurable, FComponent, FStylable, FContentConstraintable {
    public var customConfiguration: ((FButton) -> Void)?
    
    public convenience init(
        _ textPublisher: AnyPublisher<String, Never>,
        action: @escaping () -> Void
    ) {
        self.init(style: .system)
        self.bind(to: textPublisher) { button, title in
            button.setTitle(title, for: .normal)
        }
        addAction(for: .touchUpInside, action)
    }
    
    public convenience init(
        _ text: String = "",
        action: @escaping () -> Void
    ) {
        self.init(style: .system)
        self.setTitle(text, for: .normal)
        addAction(for: .touchUpInside, action)
    }

    public convenience init(@FViewBuilder label: () -> FBody, action: @escaping () -> Void) {
        self.init(style: .system)
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
}
