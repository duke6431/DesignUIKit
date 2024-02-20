//
//  FSpacer.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 12/02/2024.
//

import UIKit

public final class FSpacer: FBase<UIView>, FComponent {
    public var blurStyle: UIBlurEffect.Style?
    public var customConfiguration: ((UIView, FSpacer) -> UIView)?

    public init(width: CGFloat? = nil, height: CGFloat? = nil) {
        super.init(frame: .zero)
        self.width = width
        self.height = height
    }

    @discardableResult
    public override func rendered() -> UIView {
        var view = UIView()
        backgroundColor = contentBackgroundColor
        if !UIAccessibility.isReduceTransparencyEnabled, let blurStyle {
            let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
            view.addSubview(blurEffectView)
            blurEffectView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        view = customConfiguration?(view, self) ?? view
        content = view
        return view
    }
}

public extension FSpacer {
    func blurred(_ style: UIBlurEffect.Style) -> Self {
        with(\.blurStyle, setTo: style)
    }
}
