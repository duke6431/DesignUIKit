//
//  FSpacer.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 12/02/2024.
//

import UIKit
import SnapKit
import DesignCore
import DesignExts

public class FSpacer: BaseView, FConfigurable, FComponent {
    public var blurStyle: UIBlurEffect.Style? {
        didSet {
            if let blurStyle {
                blurView?.alpha = 1
                blurView?.effect = UIVibrancyEffect(blurEffect: .init(style: blurStyle))
            } else {
                blurView?.alpha = 0
            }
        }
    }
    public var customConfiguration: ((FSpacer) -> Void)?
    
    fileprivate weak var blurView: UIVisualEffectView?

    public init(width: CGFloat? = nil, height: CGFloat? = nil) {
        super.init(frame: .zero)
        self.configuration?.width = width
        self.configuration?.height = height
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configuration?.didMoveToSuperview(superview, with: self)
        add(blurStyle: .systemUltraThinMaterial)
        customConfiguration?(self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
    }
    
    public func add(blurStyle: UIBlurEffect.Style) {
        let blurEffectView = UIVisualEffectView(
            effect: UIVibrancyEffect(
                blurEffect: .init(style: blurStyle)
            )
        )
        blurView = blurEffectView
        addSubview(blurEffectView)
        blurEffectView.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @discardableResult
    public func blurred(_ style: UIBlurEffect.Style) -> Self {
        blurStyle = style
        return self
    }
}
