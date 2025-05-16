//
//  FSpacer.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 12/02/2024.
//

import UIKit

public final class FSpacer: BaseView, FComponent {
    public var blurStyle: UIBlurEffect.Style? {
        didSet {
            if let blurStyle {
                generateBlurIfNeeded(with: blurStyle)
                blurView?.effect = UIBlurEffect(style: blurStyle)
            } else {
                blurView?.removeFromSuperview()
                blurView = nil
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
        generateBlurIfNeeded(with: blurStyle)
        customConfiguration?(self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
    }
    
    public func generateBlurIfNeeded(with blurStyle: UIBlurEffect.Style?) {
        if blurView != nil { return }
        guard let blurStyle else { return }
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        addSubview(blurEffectView)
        blurEffectView.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
        self.blurView = blurEffectView
    }
    
    @discardableResult
    public func blurred(_ style: UIBlurEffect.Style) -> Self {
        blurStyle = style
        return self
    }
}
