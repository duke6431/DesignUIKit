//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 1/10/24.
//

import UIKit

extension UIFont.Weight {
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
