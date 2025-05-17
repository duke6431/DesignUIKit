//
//  UIFont+Weight.swift
//  DesignCore
//
//  Created by Duke Nguyen on 2024/01/10.
//
//  Extension for `UIFont.Weight` that provides string representations
//  of various font weight values.
//

import UIKit

extension UIFont.Weight {
    /// Returns a string representation of the font weight.
    ///
    /// - Returns: The name of the font weight as a string.
    var naming: String {
        switch self {
        case .ultraLight: "UltraLight"
        case .light: "Light"
        case .thin: "Thin"
        case .medium: "Medium"
        case .semibold: "Semibold"
        case .bold: "Bold"
        case .heavy: "Heavy"
        case .black: "Black"
        default: ""
        }
    }
}
