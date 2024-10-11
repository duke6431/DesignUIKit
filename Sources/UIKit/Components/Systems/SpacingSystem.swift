//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 10/01/2024.
//

import Foundation

public class SpacingSystem {
    public static let shared = SpacingSystem()
    
    var multiplier: Multiplier = .init(1)
    
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
