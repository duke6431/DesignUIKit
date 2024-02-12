//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 10/01/2024.
//

import Foundation

public class SpacingSystem: ObservableObject {
    public static let shared = SpacingSystem()
    
    @Published var multiplier: Multiplier = .regular
    
    init() { }
    
    public func spacing(_ type: CommonSpacing) -> CGFloat {
        type.value * multiplier.value
    }
}

public extension SpacingSystem {
    struct CommonSpacing {
        var value: CGFloat
        
        public init(_ value: CGFloat) { self.value = value }
    }
    
    struct Multiplier {
        var value: CGFloat
        
        public init(_ value: CGFloat) { self.value = value }
    }
}

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
