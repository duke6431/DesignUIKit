//
//  FView.swift
//
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore
import SnapKit

public final class FZStack: FBase<UIView>, FComponent {
    public var contentViews: [UIView] = []
    
    public var customConfiguration: ((UIView, FZStack) -> UIView)?
    
    public init(
        contentView: FBodyComponent? = nil
    ) {
        if let contentView {
            self.contentViews = [contentView]
        } else {
            self.contentViews = []
        }
        super.init(frame: .zero)
    }
    
    public init(
        contentViews: [UIView]
    ) {
        self.contentViews = contentViews
        super.init(frame: .zero)
    }
    
    public init(
        @FViewBuilder contentViews: () -> FBody
    ) {
        self.contentViews = contentViews()
        super.init(frame: .zero)
    }

    @discardableResult
    public override func rendered() -> UIView {
        var view = UIView()
        contentViews.forEach { subview in
            view.addSubview(subview)
            if subview as? (any FComponent & UIView) == nil {
                subview.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
            }
        }
        backgroundColor = contentBackgroundColor
        view = customConfiguration?(view, self) ?? view
        content = view
        return view
    }
}
