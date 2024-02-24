//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 17/02/2024.
//

import UIKit
import DesignCore

protocol BaseCoordinating: Chainable {
    
}

open class BaseCoordinator<ViewModel: BaseViewModel, Scene: BaseViewController<ViewModel>>: MessageHandlable, BaseCoordinating {
    open weak var navigationController: UINavigationController?
    
    public init(_ navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }
    
    open func prepare(_ viewModel: ViewModel, _ scene: Scene) {
        // Override to prepare scene if needed
    }
    
    open func toScene() {
        let viewModel = ViewModel()
        let scene = Scene(with: viewModel)
        prepare(viewModel, scene)
        navigationController?.pushViewController(scene, animated: true)
    }
}
