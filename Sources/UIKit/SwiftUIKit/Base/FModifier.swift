//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 27/9/24.
//

import Foundation

public protocol FModifier {
    typealias Content = FBodyComponent

    @discardableResult
    func body(_ content: Self.Content) -> Self.Content
}
