//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 17/02/2024.
//

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif
import DesignCore
import Combine

protocol Coordinatable {
    var coordinator: BaseCoordinating? { get }
}

open class BaseViewController<ViewModel: BaseViewModel>: BViewController, FThemableBackground {
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
    
    public var backgroundKey: ThemeKey?
    public func apply(theme: ThemeProvider) {
        guard let backgroundKey else { return }
        view.backgroundColor = theme.color(key: backgroundKey)
    }
}
