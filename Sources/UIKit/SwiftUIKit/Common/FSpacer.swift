//
//  FSpacer.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 12/02/2024.
//

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif
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
        blurView = add(blurStyle: blurStyle ?? .systemUltraThinMaterial)
        blurView?.alpha = blurStyle != nil ? 1 : 0
        customConfiguration?(self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
    }
    
    public func add(blurStyle: UIBlurEffect.Style) -> UIVisualEffectView {
        let blurEffectView = UIVisualEffectView(
            effect: UIBlurEffect(style: blurStyle)
        )
        addSubview(blurEffectView)
        blurEffectView.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
        return blurEffectView
    }
    
    @discardableResult
    public func blurred(_ style: UIBlurEffect.Style) -> Self {
        blurStyle = style
        return self
    }
}
