//
//  FSafeAreaModifier.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 14/10/24.
//

import Foundation

public struct FSafeAreaModifier: FModifier {
    var isIgnore: Bool

    public init(_ isIgnore: Bool) {
        self.isIgnore = isIgnore
    }

    public func body(_ content: FBodyComponent) -> FBodyComponent {
        content.ignoreSafeArea(isIgnore)
    }
}
