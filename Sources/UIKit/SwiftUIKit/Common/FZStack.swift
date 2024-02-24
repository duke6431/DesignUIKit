//
//  FView.swift
//
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore
import SnapKit

public class FZStack: BaseView, FConfigurable, FComponent {
    public var customConfiguration: ((FZStack) -> Void)?
    var contentViews: [UIView]
    
    public init(contentView: FBodyComponent? = nil) {
        if let contentView {
            self.contentViews = [contentView]
        } else {
            self.contentViews = []
        }
        super.init(frame: .zero)
    }
    
    init(contentViews: FBody) {
        self.contentViews = contentViews
        super.init(frame: .zero)
    }
    
    public init(@FViewBuilder _ builder: () -> FBody) {
        self.contentViews = builder()
        super.init(frame: .zero)
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configuration?.didMoveToSuperview(superview, with: self)
        contentViews.forEach(addSubview)
        customConfiguration?(self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
    }
}
