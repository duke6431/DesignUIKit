//
//  File.swift
//
//
//  Created by Duc IT. Nguyen Minh on 12/02/2024.
//

import UIKit
import DesignCore

extension UIRectCorner {
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

    static func + (_ lhs: UIEdgeInsets, _ rhs: UIEdgeInsets) -> UIEdgeInsets {
        .init(
            top: lhs.top + rhs.top,
            left: lhs.left + rhs.left,
            bottom: lhs.bottom + rhs.bottom,
            right: lhs.right + rhs.right
        )
    }

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
    static func + (_ lhs: NSDirectionalEdgeInsets, _ rhs: CGFloat) -> NSDirectionalEdgeInsets {
        lhs.custom { insets in
            insets.top += rhs
            insets.leading += rhs
            insets.trailing += rhs
            insets.bottom += rhs
        }
    }

    static func + (_ lhs: NSDirectionalEdgeInsets, _ rhs: NSDirectionalEdgeInsets) -> NSDirectionalEdgeInsets {
        .init(
            top: lhs.top + rhs.top,
            leading: lhs.leading + rhs.leading,
            bottom: lhs.bottom + rhs.bottom,
            trailing: lhs.trailing + rhs.trailing
        )
    }

    func add(_ edges: FDirectionalRectEdge, _ rhs: CGFloat) -> NSDirectionalEdgeInsets {
        return custom { insets in
            insets.top += edges.contains(.top) ? rhs : 0
            insets.leading += edges.contains(.leading) ? rhs : 0
            insets.trailing += edges.contains(.trailing) ? rhs : 0
            insets.bottom += edges.contains(.bottom) ? rhs : 0
        }
    }
}
