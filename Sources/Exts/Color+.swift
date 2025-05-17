//
//  Color+.swift
//  DesignCore
//
//  Created by Duc Minh Nguyen on 1/7/24.
//

import UIKit
import DesignCore

public extension UIColor {
    /// Initializes a UIColor object based on a hexadecimal color string.
    ///
    /// The hex string can be in one of the following formats:
    /// - RGB (3 characters, e.g. "FFF")
    /// - RRGGBB (6 characters, e.g. "FFFFFF")
    /// - AARRGGBB (8 characters, e.g. "FFFFFFFF")
    ///
    /// The alpha component is optional and defaults to 255 (fully opaque) if not provided.
    ///
    /// - Parameter hexString: The hexadecimal string representing the color.
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: .alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let alpha: UInt64
        let red: UInt64
        let green: UInt64
        let blue: UInt64
        
        switch hex.count {
        case 3:
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (alpha, red, green, blue) = (int >> 24, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: CGFloat(alpha) / 255
        )
    }
    
    /// A hexadecimal string representation of the color.
    ///
    /// The string is formatted as `#RRGGBB` representing the red, green, and blue components.
    /// Alpha component is not included in this string.
    var hexString: String {
        .init(
            format: "#%02lX%02lX%02lX",
            lroundf(Float((cgColor.components?[safe: 0] ?? 0.0) * 255)),
            lroundf(Float((cgColor.components?[safe: 1] ?? 0.0) * 255)),
            lroundf(Float((cgColor.components?[safe: 2] ?? 0.0) * 255))
        )
    }
}
