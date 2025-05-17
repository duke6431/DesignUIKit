//
//  UIFont+Weight.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 1/10/24.
//
//  Extension for UIFont.Weight to provide string representations of font weight names.
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
