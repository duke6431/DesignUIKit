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
        switch self {
        case .topLeft:
            return .layerMinXMinYCorner
        case .topRight:
            return .layerMaxXMinYCorner
        case .bottomLeft:
            return .layerMinXMaxYCorner
        case .bottomRight:
            return .layerMaxXMaxYCorner
        default:
            return [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
}

extension UIEdgeInsets: SelfCustomizable {
    static func + (_ lhs: UIEdgeInsets, _ rhs: CGFloat) -> UIEdgeInsets {
        lhs.custom { insets in
            insets.top += rhs
            insets.left += rhs
            insets.right += rhs
            insets.bottom += rhs
        }
    }
    
    func add(_ edges: UIRectEdge, _ rhs: CGFloat) -> UIEdgeInsets {
        return custom { insets in
            switch edges {
            case .top:
                insets.top += rhs
            case .left:
                insets.left += rhs
            case .right:
                insets.right += rhs
            case .bottom:
                insets.bottom += rhs
            case .all:
                insets = insets + rhs
            default:
                insets = insets + rhs
            }
        }
    }
}
