//
//  File.swift
//
//
//  Created by Duc IT. Nguyen Minh on 28/01/2024.
//

import Foundation

public extension CGSize {
    /// Combine 2 CGSize into 1 but larger
    static func + (lhs: CGSize, rhs: CGSize?) -> CGSize {
        .init(width: lhs.width + (rhs?.width ?? 0), height: lhs.height + (rhs?.height ?? 0))
    }

    /// Divide CGSize by n times
    static func / (lhs: CGSize, rhs: CGFloat) -> CGSize {
        .init(width: lhs.width / rhs, height: lhs.height / rhs)
    }
}
