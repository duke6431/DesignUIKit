//
//  CGSize+.swift
//  DesignExts
//
//  Created by Duke Nguyen on 2024/01/28.
//
//  Adds arithmetic operator extensions to `CGSize`, including
//  addition with optional sizes and division by scalar values.
//

import Foundation

public extension CGSize {
    /// Adds two `CGSize` values, returning a new `CGSize` whose width and height
    /// are the sums of the respective dimensions.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `CGSize`.
    ///   - rhs: The right-hand side optional `CGSize`.
    /// - Returns: A new `CGSize` with width and height equal to the sum of the two sizes.
    static func + (lhs: CGSize, rhs: CGSize?) -> CGSize {
        .init(width: lhs.width + (rhs?.width ?? 0), height: lhs.height + (rhs?.height ?? 0))
    }
    
    /// Divides the width and height of a `CGSize` by a given scalar value.
    ///
    /// - Parameters:
    ///   - lhs: The `CGSize` to be divided.
    ///   - rhs: The scalar value to divide by.
    /// - Returns: A new `CGSize` with width and height divided by the scalar.
    static func / (lhs: CGSize, rhs: CGFloat) -> CGSize {
        .init(width: lhs.width / rhs, height: lhs.height / rhs)
    }
}
