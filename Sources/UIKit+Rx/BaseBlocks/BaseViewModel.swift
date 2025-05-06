//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 26/9/24.
//

import Foundation

public protocol ViewModeling<Input, Output> {
    associatedtype Input
    associatedtype Output
    func transform(_ input: Input) -> Output
}

open class BaseViewModel<Navigator: BaseNavigating> {
    let navigator: Navigator
    public required init(with navigator: Navigator) {
        self.navigator = navigator
    }
}
