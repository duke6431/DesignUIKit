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

protocol BaseCoordinating: Chainable {
    
}

// TODO: Handle message `MessageHandlable`
open class BaseCoordinator<ViewModel: BaseViewModel, Scene: BaseViewController<ViewModel>>: BaseCoordinating {
    open weak var navigationController: BNavigationController?
    
    public init(_ navigationController: BNavigationController? = nil) {
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
}
