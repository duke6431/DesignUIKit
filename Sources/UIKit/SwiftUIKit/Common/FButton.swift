//
//  FButton.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore
import SnapKit

public class FButton: BaseButton, FComponent, FStylable, FContentConstraintable {
    public var customConfiguration: ((FButton) -> Void)?
    
    public init(
        _ text: String = "",
        action: @escaping () -> Void
    ) {
        super.init(frame: .zero)
        self.setTitle(text, for: .normal)
        addAction(for: .touchUpInside, action)
    }

    public init(@FViewBuilder label: () -> FBody, action: @escaping () -> Void) {
        super.init(frame: .zero)
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
