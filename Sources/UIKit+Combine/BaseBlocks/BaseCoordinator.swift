//
//  File.swift
//
//
//  Created by Duc IT. Nguyen Minh on 17/02/2024.
//

import DesignCore
import UIKit

public protocol BaseCoordinating: Chainable {
    var navigationController: UINavigationController? { get }

    func toScene() -> Self
}

// TODO: Handle message `MessageHandlable`
open class BaseCoordinator<ViewModel: BaseViewModel, Scene: FScene<ViewModel>>: BaseCoordinating, Loggable {
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
