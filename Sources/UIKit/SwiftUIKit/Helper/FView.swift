//
//  FView.swift
//  
//
//  Created by Duc Minh Nguyen on 2/20/24.
//

import UIKit
import DesignExts
import DesignCore
import SnapKit

public typealias FBodyComponent = UIView & FContaining
public typealias FBody = [FBodyComponent]
public typealias FViewBuilder = FBuilder<FBodyComponent>

open class FView: BaseView, FContaining {
    open var shadow: CALayer.ShadowConfiguration?
    open var shape: FShape?
    open var contentBackgroundColor: UIColor = .clear
    open var containerPadding: UIEdgeInsets?
    open var contentInsets: UIEdgeInsets?
    open var shouldConstraintWithParent: Bool = true
    open var opacity: CGFloat = 1
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configureViews()
        if shouldConstraintWithParent {
            snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    open func configureViews() {
        backgroundColor = contentBackgroundColor
        alpha = opacity
        subviews.forEach { $0.removeFromSuperview() }
        addSubview(
            FZStack(contentViews: body)
                .insets(contentInsets ?? .zero)
                .padding(containerPadding ?? .zero)
        )
    }

    @FViewBuilder
    open var body: FBody {
        FSpacer()
    }
}
