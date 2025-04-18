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

open class BaseViewModel {
    public init() { }
}
