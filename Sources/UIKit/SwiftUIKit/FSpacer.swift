//
//  FSpacer.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 12/02/2024.
//

import UIKit

public final class FSpacer: FBase<UIView>, FViewable {
    public var width: CGFloat = 0
    public var height: CGFloat = 0
    
    public var customConfiguration: ((UIView, FSpacer) -> UIView)?

    public init(width: CGFloat? = nil, height: CGFloat? = nil) {
        self.width = width ?? 0
        self.height = height ?? 0
        super.init(frame: .zero)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @discardableResult
    public override func rendered() -> UIView {
        var view = UIView()
        view.snp.makeConstraints {
            $0.width.equalTo(width).priority(.low)
            $0.height.equalTo(height).priority(.low)
        }
        view = customConfiguration?(view, self) ?? view
        content = view
        return view
    }
}
