//
//  BaseViewModel.swift
//  DesignRxUIKit
//
//  Created by Duke Nguyen on 2024/09/26.
//
//  Defines a protocol for view models used in MVVM architecture,
//  and provides a base class for shared functionality.
//

import Foundation

/// A protocol representing a reactive view model in MVVM architecture.
/// Defines an interface to transform input to output.
///
/// - Note: Conforming types should implement business logic and bind
///         user input to outputs exposed to the view layer.
public protocol ViewModeling<Input, Output> {
    associatedtype Input
    associatedtype Output
    /// Transforms the given input into a corresponding output.
    /// - Parameter input: The input to transform.
    /// - Returns: The resulting output.
    func transform(_ input: Input) -> Output
}

/// A base class for view models that provides a shared initializer.
/// Subclass this to implement view model-specific logic and bindings.
open class BaseViewModel<Navigator: BaseNavigating> {
    let navigator: Navigator
    public required init(with navigator: Navigator) {
        self.navigator = navigator
    }
}
