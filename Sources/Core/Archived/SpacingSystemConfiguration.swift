//
//  File.swift
//  ComponentSystem
//
//  Created by Duke Nguyen on 26/9/24.
//

import Foundation

public extension SpacingSystem.Multiplier {
    static var allCases: [Self] {
        [.extraSmall, .small, .regular, .large, .extraLarge]
    }

    fileprivate(set) static var extraSmall = SpacingSystem.Multiplier(0.4)
    fileprivate(set) static var small = SpacingSystem.Multiplier(0.7)
    fileprivate(set) static var regular = SpacingSystem.Multiplier(1)
    fileprivate(set) static var large = SpacingSystem.Multiplier(1.3)
    fileprivate(set) static var extraLarge = SpacingSystem.Multiplier(1.6)
}

public extension SpacingSystem.CommonSpacing {
    fileprivate(set) static var base = SpacingSystem.CommonSpacing(2)
    fileprivate(set) static var extraSmall = SpacingSystem.CommonSpacing(4)
    fileprivate(set) static var small = SpacingSystem.CommonSpacing(8)
    fileprivate(set) static var regular = SpacingSystem.CommonSpacing(16)
    fileprivate(set) static var large = SpacingSystem.CommonSpacing(24)
    fileprivate(set) static var extraLarge = SpacingSystem.CommonSpacing(32)
}
