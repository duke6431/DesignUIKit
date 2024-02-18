//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 17/02/2024.
//

import UIKit

open class FContainer: BaseView {
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configureViews()
    }
    
    open func configureViews() {
        backgroundColor = .white
        subviews.forEach { $0.removeFromSuperview() }
        addSubview(body)
    }
    
    open var body: UIView {
        fatalError("Overridden required")
    }
}
