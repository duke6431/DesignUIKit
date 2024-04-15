//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 3/21/24.
//

#if canImport(UIKit)
import UIKit

/// Unification of RectEdge
public typealias BRectEdge = UIRectEdge
/// Unification of Font
public typealias BFont = UIFont
/// Unification of Color
public typealias BColor = UIColor
/// Unification of Image
public typealias BImage = UIImage
/// Unification of EdgeInsets
public typealias BEdgeInsets = UIEdgeInsets
/// Unification of Axis
public typealias BAxis = NSLayoutConstraint.Axis
/// Unification of Layout priority
public typealias BLayoutPriority = UILayoutPriority
/// Unification of Rect corner
public typealias BRectCorner = UIRectCorner
#else
import AppKit

public typealias BFont = NSFont
public typealias BColor = NSColor
public typealias BImage = NSImage
public typealias BEdgeInsets = NSEdgeInsets
public typealias BAxis = NSLayoutConstraint.Orientation
public typealias BLayoutPriority = NSLayoutConstraint.Priority

public struct BRectCorner: OptionSet, @unchecked Sendable {
    public let rawValue: UInt
    
    public init(rawValue: UInt) { self.rawValue = rawValue }
    
    public static var topLeft: BRectCorner {
        .init(rawValue: 1 << 0)
    }
    
    public static var topRight: BRectCorner {
        .init(rawValue: 1 << 1)
    }
    
    public static var bottomLeft: BRectCorner {
        .init(rawValue: 1 << 2)
    }
    
    public static var bottomRight: BRectCorner {
        .init(rawValue: 1 << 3)
    }
    
    public static var allCorners: BRectCorner {
        .init(rawValue: topLeft.rawValue | topRight.rawValue | bottomLeft.rawValue | bottomRight.rawValue)
    }
}
#endif
