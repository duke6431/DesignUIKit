//
//  BaseNavigator.swift
//  DesignRxUIKit
//
//  Created by Duke Nguyen on 2024/09/26.
//
//  Defines a base navigation interface and its default implementation using `UINavigationController`.
//  Provides a protocol for modular navigation coordination and a base class for navigation handling.
//

import DesignCore
import RxCocoa
import UIKit

/// A protocol representing a base navigator that exposes a `UINavigationController`.
/// Conforming types can coordinate navigation logic and flow.
public protocol BaseNavigating: Chainable {
    /// The `UINavigationController` used for managing the navigation stack.
    var navigationController: UINavigationController? { get }
}

/// A default implementation of `BaseNavigating` that holds a weak reference
/// to a `UINavigationController` for navigation coordination.
open class BaseNavigator: BaseNavigating {
    /// The `UINavigationController` instance used to perform navigation.
    /// Held as a weak reference to avoid retain cycles.
    open weak var navigationController: UINavigationController?
    
    /// Initializes a new `BaseNavigator` with an optional navigation controller.
    /// - Parameter navigationController: The navigation controller to use.
    public init(_ navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }
}
