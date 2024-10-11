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
}

open class BaseNavigator: BaseNavigating {
    open weak var navigationController: UINavigationController?
    
    public init(_ navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }
}
