//
//  File.swift
//
//
//  Created by Duc Minh Nguyen on 1/7/24.
//

import Foundation
import DesignCore

public extension BColor {
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
    
    var hexString: String {
        .init(
            format: "#%02lX%02lX%02lX",
            lroundf(Float((cgColor.components?[safe: 0] ?? 0.0) * 255)),
            lroundf(Float((cgColor.components?[safe: 1] ?? 0.0) * 255)),
            lroundf(Float((cgColor.components?[safe: 2] ?? 0.0) * 255))
        )
    }
}
