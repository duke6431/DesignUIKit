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

public typealias FBodyComponent = UIView & FConfigurable
public typealias FBody = [FBodyComponent]
public typealias FViewBuilder = FBuilder<FBodyComponent>

open class FView: BaseView, FConfigurable, FComponent {
    public var customConfiguration: ((FView) -> Void)?

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configureViews()
        configuration?.didMoveToSuperview(superview, with: self)
        customConfiguration?(self)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
    }
    
    open func configureViews() {
        addSubview(body)
    }
    
    open var body: FBodyComponent {
        fatalError("Variable body of \(String(describing: self)) must be overridden")
    }
}

open class FScene<ViewModel: BaseViewModel>: BaseViewController<ViewModel> {
    open override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    open override func configureViews() {
        super.configureViews()
        view.addSubview(body)
    }
    
    open var body: FBodyComponent {
        fatalError("Variable body of \(String(describing: self)) must be overridden")
    }
}
