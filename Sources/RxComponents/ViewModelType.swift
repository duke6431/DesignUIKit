//
//  ViewModelType.swift
//  DesignRx
//
//  Created by Duc IT. Nguyen Minh on 07/01/2023.
//

import Foundation

public protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
