//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 3/21/24.
//

#if canImport(UIKit)
import UIKit

public typealias BRectEdge = UIRectEdge
public typealias BFont = UIFont
public typealias BColor = UIColor
public typealias BImage = UIImage
public typealias BEdgeInsets = UIEdgeInsets
public typealias BAxis = NSLayoutConstraint.Axis
public typealias BLayoutPriority = UILayoutPriority
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
