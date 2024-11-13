//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 26/9/24.
//

import DesignCore
import RxCocoa
import UIKit

public protocol BaseNavigating: Chainable {
    var navigationController: UINavigationController? { get }

    func toScene() -> Self
}

open class BaseNavigator<ViewModel: BaseViewModel, Scene: FScene<ViewModel>>: BaseNavigating, Loggable {
    open weak var navigationController: UINavigationController?
    
    public init(_ navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }
    
    open func prepare(_ viewModel: ViewModel, _ scene: Scene) {
        // Override to prepare scene if needed
    }
    
    @discardableResult
    open func toScene() -> Self {
        let viewModel = ViewModel()
        let scene = Scene(with: viewModel)
        prepare(viewModel, scene)
        navigationController?.pushViewController(scene, animated: true)
        return self
    }
    
    deinit {
#if CORE_DEBUG
        logger.info("Deinitialized \(self)")
#endif
    }
}
