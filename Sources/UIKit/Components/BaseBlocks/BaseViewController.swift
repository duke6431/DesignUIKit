//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 17/02/2024.
//

import UIKit
import Combine

open class BaseViewController<ViewModel: BaseViewModel>: UIViewController {
    open var viewModel: ViewModel
    open var cancellables = Set<AnyCancellable>()
    
    public required init(with viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(iOS, unavailable)
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
        
    }
}
