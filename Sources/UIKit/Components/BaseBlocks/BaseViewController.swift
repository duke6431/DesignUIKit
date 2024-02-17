//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 17/02/2024.
//

import UIKit
import Combine

public class BaseViewController<ViewModel: BaseViewModel>: UIViewController {
    var viewModel: ViewModel
    var cancellables = Set<AnyCancellable>()
    
    required init(with viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(iOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Coder init not required")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        bindViewModel()
    }
    
    func configureViews() {
        
    }
    
    func bindViewModel() {
        
    }
}
