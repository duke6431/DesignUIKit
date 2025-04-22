//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 26/9/24.
//

import DesignCore
import RxCocoa
import UIKit

public protocol BaseCoordinating: Chainable {
    var navigationController: UINavigationController? { get }

    func toScene() -> Self
}

open class BaseCoordinator: BaseCoordinating, Loggable {
    open weak var navigationController: UINavigationController?

    public init(_ navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }
    
    public func toScene() -> Self {
        return self
    }

    deinit {
#if CORE_DEBUG
        logger.info("Deinitialized \(self)")
#endif
    }
}
