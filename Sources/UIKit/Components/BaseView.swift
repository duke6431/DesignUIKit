//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 15/02/2024.
//

import UIKit

open class BaseView: UIView {
    public override init(frame: CGRect = .zero) {
        super.init(frame: .zero)
    }
    
    @available(iOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }
}

open class BaseScrollView: UIScrollView {
    public override init(frame: CGRect = .zero) {
        super.init(frame: .zero)
    }
    
    @available(iOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }
}
