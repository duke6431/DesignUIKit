//
//  FSpacer.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 12/02/2024.
//

import UIKit
import DesignCore
import DesignExts

public class FSpacer: BaseView, FConfigurable, FComponent {
    public var blurStyle: UIBlurEffect.Style?
    public var customConfiguration: ((FSpacer) -> Void)?

    public init(width: CGFloat? = nil, height: CGFloat? = nil) {
        super.init(frame: .zero)
        self.configuration?.width = width
        self.configuration?.height = height
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configuration?.didMoveToSuperview(superview, with: self)
        if !UIAccessibility.isReduceTransparencyEnabled, let blurStyle {
            let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
            addSubview(blurEffectView)
            blurEffectView.snp.remakeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        customConfiguration?(self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
    }
    
    public func blurred(_ style: UIBlurEffect.Style) -> Self {
        blurStyle = style
        return self
    }
}
