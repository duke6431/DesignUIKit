//
//  BaseViewController.swift
//  DesignRxUIKit
//
//  Created by Duke Nguyen on 2024/09/26.
//
//  Defines a base view controller with theming and RxSwift binding capabilities,
//  and a generic `FScene` subclass for MVVM architecture. Provides hooks for
//  view configuration, input preparation, and output handling.
//

import UIKit
import RxSwift
import RxCocoa
import DesignCore
import DesignUIKit

/// A base view controller providing RxSwift support and theme-based background color.
/// Intended to be subclassed by feature-specific view controllers.
open class BaseViewController: UIViewController, FThemableBackground {
    /// The dispose bag used to manage RxSwift subscriptions.
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
    
    /// Override point for setting up UI components and layout constraints.
    open func configureViews() { }
    
	open func bindViewModel() { }

    /// The theme key used to determine the background color of the view.
    public var backgroundKey: ThemeKey?
    /// Applies the background color using the current theme and `backgroundKey`.
    /// - Parameter theme: The theme provider for resolving theme keys.
    public func apply(theme: ThemeProvider) {
        guard let backgroundKey else { return }
        view.backgroundColor = theme.color(key: backgroundKey)
    }
}

/// A generic scene controller for binding a `ViewModeling` view model.
/// Provides hooks for preparing input, handling output, and rendering the view hierarchy.
open class FScene<ViewModel: ViewModeling>: BaseViewController {
    /// The view model associated with the scene, conforming to `ViewModeling`.
    open var viewModel: ViewModel
    /// Initializes the scene with a view model instance.
    /// - Parameter viewModel: The view model to bind to the scene.
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
    
    /// The root UI content of the scene. Must be overridden by subclasses.
    open var body: FBodyComponent {
        fatalError("Variable body of \(String(describing: self)) must be overridden")
    }
    
    /// Connects the view model input/output to the scene using `handle(_: ViewModel.Output)`.
    open override func bindViewModel() {
        disposeBag.insert(handle(viewModel.transform(input)))
    }
    
    /// Handles the view model output and returns a list of disposables to manage.
    /// - Parameter output: The output produced by the view model transformation.
    /// - Returns: An array of RxSwift `Disposable` instances.
    @FBuilder<Disposable>
    open func handle(_ output: ViewModel.Output) -> [Disposable] {
        fatalError("\(String(describing: ViewModel.self))'s output was not handled")
    }
    
    /// Prepares the input for the view model transformation. Must be overridden.
    /// - Returns: A valid `ViewModel.Input` object.
    open var input: ViewModel.Input {
        fatalError("\(String(describing: ViewModel.self))'s input was not prepared")
    }
}

/// Conformance to `Disposable` for `Never`, enabling fallback in generic contexts.
extension Never: Disposable {
    public func dispose() { }
}
