//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 4/17/24.
//

import Foundation

public extension Theme {
    /// Theme might only has 2 styles: dark and light
    @frozen
    enum Style: String, Codable {
        case light
        case dark
    }
    
    struct Palette: Codable, Hashable {
        var style: Style
        var colors: [String: String]
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(style)
        }
        
        subscript(_ key: String) -> String? {
            get {
                colors[key]
            }
            set {
                colors[key] = newValue
            }
        }
    }
}

extension Set where Element == Theme.Palette {
    subscript(_ style: Theme.Style) -> Element? {
        first { $0.style == style }
    }
}
