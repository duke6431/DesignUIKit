//
//  File.swift
//
//
//  Created by Duke Nguyen on 17/02/2024.
//

import DesignCore
import UIKit

@MainActor public protocol BaseNavigating: Chainable {
    var navigationController: UINavigationController? { get set }

    func toScene() -> Self
}

// TODO: Handle message `MessageHandlable`
@MainActor open class BaseNavigator<ViewModel: BaseViewModel, Scene: FScene<ViewModel>>: BaseNavigating, Loggable {
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
        logger.trace("Deinitialized \(self)")
    }
}
