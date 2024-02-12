//
//  FView.swift
//
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore
import SnapKit

public class FView: FViewable {
    public var subviews: [AnyViewable]
    public var customConfiguration: ((UIView, FView) -> UIView)?
    
    public init(
        subview: AnyViewable? = nil,
        customConfiguration: ((UIView, FView) -> UIView)? = nil
    ) {
        if let subview {
            self.subviews = [subview]
        } else {
            self.subviews = []
        }
        self.customConfiguration = customConfiguration
    }
    
    public init(
        @FBuilder<AnyViewable> subviews: () -> [AnyViewable],
        customConfiguration: ((UIView, FView) -> UIView)? = nil
    ) {
        self.subviews = subviews()
        self.customConfiguration = customConfiguration
    }
    
    public func rendered() -> UIView {
        let view = UIView()
        subviews.forEach { subview in
            let subview = subview.rendered()
            view.addSubview(subview)
            subview.snp.makeConstraints { $0.edges.equalToSuperview() }
        }
        return customConfiguration?(view, self) ?? view
    }
}
