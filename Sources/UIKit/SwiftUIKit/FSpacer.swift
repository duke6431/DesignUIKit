//
//  FSpacer.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 12/02/2024.
//

import UIKit

public class FSpacer: FViewable {
    public var width: CGFloat
    public var height: CGFloat
    
    public var customConfiguration: ((UIView, FSpacer) -> UIView)?
    
    public init(width: CGFloat? = nil, height: CGFloat? = nil) {
        self.width = width ?? 0
        self.height = height ?? 0
    }
    public func rendered() -> UIView {
        let view = UIView()
        view.snp.makeConstraints {
            $0.width.equalTo(width).priority(.low)
            $0.height.equalTo(height).priority(.low)
        }
        return view
    }
}
