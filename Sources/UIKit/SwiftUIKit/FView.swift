//
//  FView.swift
//
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore
import SnapKit

public final class FView: FBase<UIView>, FViewable {
    public var contentViews: [AnyViewable] = []
    
    public var customConfiguration: ((UIView, FView) -> UIView)?
    
    public init(
        contentView: AnyViewable? = nil,
        customConfiguration: ((UIView, FView) -> UIView)? = nil
    ) {
        if let contentView {
            self.contentViews = [contentView]
        } else {
            self.contentViews = []
        }
        self.customConfiguration = customConfiguration
        super.init(frame: .zero)
    }
    
    public init(
        @FBuilder<AnyViewable> contentViews: () -> [AnyViewable],
        customConfiguration: ((UIView, FView) -> UIView)? = nil
    ) {
        self.contentViews = contentViews()
        self.customConfiguration = customConfiguration
        super.init(frame: .zero)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @discardableResult
    public override func rendered() -> UIView {
        var view = UIView()
        contentViews.forEach { subview in
            let subview = subview.rendered()
            view.addSubview(subview)
            subview.snp.makeConstraints { $0.edges.equalToSuperview() }
        }
        view.backgroundColor = backgroundColor
        view = customConfiguration?(view, self) ?? view
        content = view
        return view
    }
}
