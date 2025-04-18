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

open class BaseViewController: UIViewController, FThemableBackground {
    open var disposeBag = DisposeBag()

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

    open func configureViews() { }
    
    open func bindViewModel() { }

    public var backgroundKey: ThemeKey?
    public func apply(theme: ThemeProvider) {
        guard let backgroundKey else { return }
        view.backgroundColor = theme.color(key: backgroundKey)
    }
}

open class FScene<ViewModel: ViewModeling>: BaseViewController {
    open var viewModel: ViewModel
    public required init(with viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    open override func configureViews() {
        super.configureViews()
        view.addSubview(body)
    }

    open var body: FBodyComponent {
        fatalError("Variable body of \(String(describing: self)) must be overridden")
    }
    
    open func bindViewModel() {
        disposeBag.insert(handle(viewModel.transform(input)))
    }
    
    @FBuilder<Disposable>
    open func handle(_ output: ViewModel.Output) -> [Disposable] {
        fatalError("\(String(describing: ViewModel.self))'s output was not handled")
    }
    
    open var input: ViewModel.Input {
        fatalError("\(String(describing: ViewModel.self))'s input was not prepared")
    }
}

extension Never: Disposable {
    public func dispose() { }
}
