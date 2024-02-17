//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 17/02/2024.
//

import UIKit

open class BaseCoordinator<ViewModel: BaseViewModel, Scene: BaseViewController<ViewModel>>: MessageHandlable {
    open weak var navigationController: UINavigationController?
    
    public init(_ navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }
    
    open func prepare(_ scene: Scene) {
        // Override to prepare scene if needed
    }
    
    public func toScene() {
        let scene = Scene(with: ViewModel())
        prepare(scene)
        navigationController?.pushViewController(scene, animated: true)
    }
}
