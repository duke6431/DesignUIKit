//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 12/02/2024.
//

import UIKit
import SnapKit
import DesignCore

public final class FScroll: FBase<UIScrollView>, FComponent {
    public var contentViews: [UIView] = []
    public var showsVerticalScrollIndicator: Bool = false
    
    public var customConfiguration: ((UIScrollView, FScroll) -> UIScrollView)?
    
    public init(
        contentView: UIView? = nil,
        customConfiguration: ((UIScrollView, FScroll) -> UIScrollView)? = nil
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
        @FBuilder<UIView> contentViews: () -> [UIView],
        customConfiguration: ((UIScrollView, FScroll) -> UIScrollView)? = nil
    ) {
        self.contentViews = contentViews()
        self.customConfiguration = customConfiguration
        super.init(frame: .zero)
    }

    @discardableResult
    public override func rendered() -> UIScrollView {
        var view = UIScrollView()
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        var topAnchor = view.snp.top
        contentViews.enumerated().forEach { index, subview in
            view.addSubview(subview)
            subview.snp.makeConstraints {
                $0.top.equalTo(topAnchor)
                $0.leading.trailing.centerX.equalToSuperview()
            }
            topAnchor = subview.snp.bottom
        }
        view.snp.makeConstraints {
            $0.bottom.equalTo(topAnchor)
        }
        backgroundColor = contentBackgroundColor
        view = customConfiguration?(view, self) ?? view
        content = view
        return view
    }
}
