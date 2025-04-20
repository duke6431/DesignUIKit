//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 27/9/24.
//

import Foundation

public protocol FModifier {
    @discardableResult
    func body(_ content: FBodyComponent) -> FBodyComponent
}
