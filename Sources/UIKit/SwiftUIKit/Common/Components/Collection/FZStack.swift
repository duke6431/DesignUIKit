//
//  FView.swift
//
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import DesignCore

public final class FZStack: BaseView, FComponent {
    public var customConfiguration: ((FZStack) -> Void)?
    public var contentViews: FBody

    public init(contentView: FBodyComponent? = nil) {
        if let contentView {
            self.contentViews = [contentView]
        } else {
            self.contentViews = []
        }
        super.init(frame: .zero)
    }

    public convenience init(@FViewBuilder _ builder: () -> FBody) {
        self.init(contentViews: builder())
    }

    public init(contentViews: FBody) {
        self.contentViews = contentViews
        super.init(frame: .zero)
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configuration?.didMoveToSuperview(superview, with: self)
        contentViews.flatMap {
            ($0 as? FForEach)?.content() ?? [$0]
        }.forEach(addSubview)
        customConfiguration?(self)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
    }
}
