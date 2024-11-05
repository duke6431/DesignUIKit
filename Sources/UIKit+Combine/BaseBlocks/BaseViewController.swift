//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 17/02/2024.
//

import Foundation
import DesignCore
import DesignUIKit
import Combine
import UIKit

open class BaseViewController: UIViewController, FThemableBackground, Loggable {
    open var cancellables = Set<AnyCancellable>()
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Coder init not required")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        bindViewModel()
    }
    
    open func configureViews() {
        
    }
    
    open func bindViewModel() {
        bindError()
    }
    
    @objc open dynamic func bindError() { }
    
    public var backgroundKey: ThemeKey?
    public func apply(theme: ThemeProvider) {
        guard let backgroundKey else { return }
        view.backgroundColor = theme.color(key: backgroundKey)
    }
    
    deinit {
        logger.info("Deinitialized \(self)")
    }
}

open class FScene<ViewModel: BaseViewModel>: BaseViewController {
    open var viewModel: ViewModel
    
    public required init(with viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    open override func configureViews() {
        super.configureViews()
        view.addSubview(body)
    }
    
    open var body: FBodyComponent {
        fatalError("Variable body of \(String(describing: self)) must be overridden")
    }
}
