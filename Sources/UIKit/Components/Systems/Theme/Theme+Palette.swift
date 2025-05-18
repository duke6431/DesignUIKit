//
//  Theme+Palette.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2024/04/17.
//
//  This file defines the `Theme.Style` enum representing the theme styles (light and dark),
//  and the `Theme.Palette` struct which holds color palettes associated with a particular style.
//  It also provides an extension on `Set` to conveniently access a palette by its style.
//

import Foundation

public extension Theme {
    /// Represents the style of a theme.
    ///
    /// A theme can have two styles:
    /// - `light`: The light appearance style.
    /// - `dark`: The dark appearance style.
    @frozen
    enum Style: String, Codable {
        /// Light theme style.
        case light
        /// Dark theme style.
        case dark
    }
    
    /// A color palette associated with a specific theme style.
    ///
    /// Contains a dictionary of color values keyed by their names.
    struct Palette: Codable, Hashable {
        /// The style of the theme this palette corresponds to.
        var style: Style
        
        /// A dictionary mapping color names to their string representations.
        var colors: [String: String]

        public func hash(into hasher: inout Hasher) {
            hasher.combine(style)
        }
        
        /// Accesses the color value for the given color name.
        ///
        /// - Parameter key: The name of the color.
        /// - Returns: The string representation of the color if it exists, otherwise `nil`.
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
    /// Returns the palette matching the given style, if it exists in the set.
    ///
    /// - Parameter style: The theme style to look for.
    /// - Returns: The `Theme.Palette` with the matching style, or `nil` if not found.
    subscript(_ style: Theme.Style) -> Element? {
        first { $0.style == style }
    }
}
