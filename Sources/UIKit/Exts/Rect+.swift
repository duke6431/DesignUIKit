//
//  Rect+.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2024/02/12.
//
//  Provides convenience methods and operator overloads for manipulating
//  `UIRectCorner`, `UIEdgeInsets`, and `NSDirectionalEdgeInsets`.
//

import UIKit
import DesignCore

extension UIRectCorner {
    /// Returns the corresponding `CACornerMask` for the `UIRectCorner`.
    ///
    /// This computed property converts the `UIRectCorner` options to the equivalent
    /// `CACornerMask` values used for layer corner masking.
    var caMask: CACornerMask {
        var masks: [CACornerMask] = []
        if self.contains(.topLeft) {
            masks.append(.layerMinXMinYCorner)
        }
        if self.contains(.topRight) {
            masks.append(.layerMaxXMinYCorner)
        }
        if self.contains(.bottomLeft) {
            masks.append(.layerMinXMaxYCorner)
        }
        if self.contains(.bottomRight) {
            masks.append(.layerMaxXMaxYCorner)
        }
        return .init(masks)
    }
}

extension UIEdgeInsets: SelfCustomizable {
    static func += (_ lhs: inout UIEdgeInsets, _ rhs: CGFloat) {
        lhs.custom { insets in
            insets.top += rhs
            insets.left += rhs
            insets.right += rhs
            insets.bottom += rhs
        }
    }

    /// Adds a scalar value to all edges of the `UIEdgeInsets`.
    ///
    /// - Parameters:
    ///   - lhs: The original `UIEdgeInsets`.
    ///   - rhs: The scalar `CGFloat` value to add to each edge.
    /// - Returns: A new `UIEdgeInsets` with each edge increased by `rhs`.
    static func + (_ lhs: UIEdgeInsets, _ rhs: CGFloat) -> UIEdgeInsets {
        lhs.custom { insets in
            insets.top += rhs
            insets.left += rhs
            insets.right += rhs
            insets.bottom += rhs
        }
    }

    static func += (_ lhs: inout UIEdgeInsets, _ rhs: UIEdgeInsets) {
        lhs.custom {
            $0.top += rhs.top
            $0.left += rhs.left
            $0.bottom += rhs.bottom
            $0.right += rhs.right
        }
    }

    
    /// Adds the values of two `UIEdgeInsets` instances edge-wise.
    ///
    /// - Parameters:
    ///   - lhs: The first `UIEdgeInsets`.
    ///   - rhs: The second `UIEdgeInsets`.
    /// - Returns: A new `UIEdgeInsets` where each edge is the sum of the corresponding edges.
    static func + (_ lhs: UIEdgeInsets, _ rhs: UIEdgeInsets) -> UIEdgeInsets {
        .init(
            top: lhs.top + rhs.top,
            left: lhs.left + rhs.left,
            bottom: lhs.bottom + rhs.bottom,
            right: lhs.right + rhs.right
        )
    }
    
    /// Adds a scalar value to specific edges of the `UIEdgeInsets`.
    ///
    /// - Parameters:
    ///   - edges: The edges to which the scalar value should be added.
    ///   - rhs: The scalar `CGFloat` value to add.
    /// - Returns: A new `UIEdgeInsets` with the specified edges increased by `rhs`.
    func add(_ edges: UIRectEdge, _ rhs: CGFloat) -> UIEdgeInsets {
        return custom { insets in
            insets.top += edges.contains(.top) ? rhs : 0
            insets.bottom += edges.contains(.bottom) ? rhs : 0
            insets.left += edges.contains(.left) ? rhs : 0
            insets.right += edges.contains(.right) ? rhs : 0
        }
    }
}

extension NSDirectionalEdgeInsets: SelfCustomizable {
    /// Adds a scalar value to all edges of the `NSDirectionalEdgeInsets`.
    ///
    /// - Parameters:
    ///   - lhs: The original `NSDirectionalEdgeInsets`.
    ///   - rhs: The scalar `CGFloat` value to add to each edge.
    /// - Returns: A new `NSDirectionalEdgeInsets` with each edge increased by `rhs`.
    static func + (_ lhs: NSDirectionalEdgeInsets, _ rhs: CGFloat) -> NSDirectionalEdgeInsets {
        lhs.custom { insets in
            insets.top += rhs
            insets.leading += rhs
            insets.trailing += rhs
            insets.bottom += rhs
        }
    }
    
    /// Adds the values of two `NSDirectionalEdgeInsets` instances edge-wise.
    ///
    /// - Parameters:
    ///   - lhs: The first `NSDirectionalEdgeInsets`.
    ///   - rhs: The second `NSDirectionalEdgeInsets`.
    /// - Returns: A new `NSDirectionalEdgeInsets` where each edge is the sum of the corresponding edges.
    static func + (_ lhs: NSDirectionalEdgeInsets, _ rhs: NSDirectionalEdgeInsets) -> NSDirectionalEdgeInsets {
        .init(
            top: lhs.top + rhs.top,
            leading: lhs.leading + rhs.leading,
            bottom: lhs.bottom + rhs.bottom,
            trailing: lhs.trailing + rhs.trailing
        )
    }
    
    /// Adds a scalar value to specific edges of the `NSDirectionalEdgeInsets`.
    ///
    /// - Parameters:
    ///   - edges: The directional edges to which the scalar value should be added.
    ///   - rhs: The scalar `CGFloat` value to add.
    /// - Returns: A new `NSDirectionalEdgeInsets` with the specified edges increased by `rhs`.
    func add(_ edges: NSDirectionalRectEdge, _ rhs: CGFloat) -> NSDirectionalEdgeInsets {
        return custom { insets in
            insets.top += edges.contains(.top) ? rhs : 0
            insets.leading += edges.contains(.leading) ? rhs : 0
            insets.trailing += edges.contains(.trailing) ? rhs : 0
            insets.bottom += edges.contains(.bottom) ? rhs : 0
        }
    }
}
