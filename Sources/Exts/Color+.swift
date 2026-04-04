//
//  Color+.swift
//  DesignExts
//
//  Created by Duke Nguyen on 2024/01/07.
//
//  Adds convenience initializers and computed properties to `UIColor`
//  for working with hexadecimal string representations.
//

import UIKit
import DesignCore

public extension UIColor {
    /// Creates a `UIColor` instance from a hexadecimal string.
    ///
    /// - Parameter code: A hexadecimal string in 3, 6, or 8 character format (e.g., "FFF", "FFFFFF", "AARRGGBB").
    /// - Returns: A `UIColor` parsed from the provided hex string.
    class func hex(_ code: String) -> UIColor {
        .init(hexString: code)
    }
    
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
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return .init(
                format: "#%02lX%02lX%02lX",
                lroundf(Float(red * 255)),
                lroundf(Float(green * 255)),
                lroundf(Float(blue * 255))
            )
        }
        guard let rgbColorSpace = CGColorSpace(name: CGColorSpace.sRGB),
              let converted = cgColor.converted(to: rgbColorSpace, intent: .defaultIntent, options: nil),
              let components = converted.components,
              components.count >= 3
        else {
            return "#000000"
        }
        return .init(
            format: "#%02lX%02lX%02lX",
            lroundf(Float(components[0] * 255)),
            lroundf(Float(components[1] * 255)),
            lroundf(Float(components[2] * 255))
        )
    }
}
