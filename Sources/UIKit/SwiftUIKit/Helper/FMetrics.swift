//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 5/12/24.
//

import Foundation

public struct FAxis: OptionSet, Hashable, @unchecked Sendable, ExpressibleByIntegerLiteral {
    public var rawValue: Int
    
    public init(rawValue: Int) { self.rawValue = rawValue }
    public init(integerLiteral value: Int) { self.rawValue = value }
    
    public static let horizontal: FAxis = .init(rawValue: 1 << 0)
    public static let vertical: FAxis = .init(rawValue: 1 << 1)
    public static let all: FAxis = [.horizontal, .vertical]
}

extension FAxis {
    var rawAxes: [FAxis] {
        var axes: [FAxis] = []
        if contains(.horizontal) { axes.append(.horizontal) }
        if contains(.vertical) { axes.append(.vertical) }
        return axes
    }
}

public struct FDirectionalRectEdge: OptionSet, Hashable, @unchecked Sendable, ExpressibleByIntegerLiteral {
    public var rawValue: Int
    
    public init(rawValue: Int) { self.rawValue = rawValue }
    public init(integerLiteral value: Int) { self.rawValue = value }
    
    public static let top: FDirectionalRectEdge = .init(rawValue: 1 << 0)
    public static let bottom: FDirectionalRectEdge = .init(rawValue: 1 << 1)
    public static let leading: FDirectionalRectEdge = .init(rawValue: 1 << 2)
    public static let trailing: FDirectionalRectEdge = .init(rawValue: 1 << 3)
    
    public static let all: FDirectionalRectEdge = [.top, .bottom, .leading, .trailing]
    public static let vertical: FDirectionalRectEdge = [.top, .bottom]
    public static let horizontal: FDirectionalRectEdge = [.leading, .trailing]
}

extension FDirectionalRectEdge {
    var rawEdges: [FDirectionalRectEdge] {
        var edges: [FDirectionalRectEdge] = []
        if contains(.top) { edges.append(.top) }
        if contains(.bottom) { edges.append(.bottom) }
        if contains(.leading) { edges.append(.leading) }
        if contains(.trailing) { edges.append(.trailing) }
        return edges
    }
}

