//
//  FView.swift
//
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif
import DesignCore
import SnapKit

public class FZStack: BaseView, FComponent {
    public var layoutConfiguration: ((ConstraintMaker, UIView) -> Void)?
    public var customConfiguration: ((FZStack) -> Void)?
    public var contentViews: [FBodyComponent]
    
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
        contentViews.forEach(addSubview)
        if let layoutConfiguration, let superview {
            snp.makeConstraints { make in
                layoutConfiguration(make, superview)
            }
        }
        customConfiguration?(self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
    }
}
