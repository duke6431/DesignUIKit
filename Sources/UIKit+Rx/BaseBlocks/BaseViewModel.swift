//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 26/9/24.
//

import Foundation
import DesignCore
import RxSwift
import RxCocoa

public protocol ViewModeling<Input, Output> {
    associatedtype Input
    associatedtype Output
    func connect(_ input: Input, with output: Output, disposeBag: DisposeBag)
}

open class BaseViewModel {
    public init() { }
}
