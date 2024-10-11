//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 26/9/24.
//

import UIKit
import RxSwift
import RxCocoa
import DesignCore
import DesignUIKit

open class BaseViewController<ViewModel: ViewModeling>: UIViewController, FThemableBackground {
    open var viewModel: ViewModel
    open var disposeBag = DisposeBag()
    
    public required init(with viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Coder init not required")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        viewModel.connect(input, with: output)
    }
    
    open func configureViews() { }
    
    open var input: ViewModel.Input {
        fatalError("Input was not prepared")
    }
    
    open var output: ViewModel.Output {
        fatalError("Output was not prepared")
    }
    
    public var backgroundKey: ThemeKey?
    public func apply(theme: ThemeProvider) {
        guard let backgroundKey else { return }
        view.backgroundColor = theme.color(key: backgroundKey)
    }
}

open class FScene<ViewModel: ViewModeling>: BaseViewController<ViewModel> {
    open override func configureViews() {
        super.configureViews()
        view.addSubview(body)
    }
    
    open var body: FBodyComponent {
        fatalError("Variable body of \(String(describing: self)) must be overridden")
    }
}
