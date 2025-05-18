//
//  CommonProtocols.swift
//  DesignCore
//
//  Created by Duke Nguyen on 2022/05/17.
//
//  This file defines the `FBuilder` result builder, which provides a declarative way to construct
//  collections of nodes. It supports combining multiple nodes, optional nodes, conditional branches,
//  and arrays of nodes into a single flat array of nodes.
//

import Foundation

/// A result builder that constructs an array of nodes from a declarative syntax.
///
/// `FBuilder` enables building arrays of `Node` elements using Swift's result builder feature.
/// It provides methods to combine multiple nodes, handle optional nodes, conditional branches,
/// and arrays of nodes into a single flat array.
///
/// - Note: `Node` is a generic placeholder representing the type of elements being built.
@resultBuilder
public enum FBuilder<Node> {
    /// Returns an empty array of nodes.
    ///
    /// Used when no child nodes are provided.
    public static func buildBlock() -> [Node] { [] }
    
    /// Combines a variadic list of nodes into an array.
    ///
    /// - Parameter children: A variadic list of nodes.
    /// - Returns: An array containing all provided nodes.
    public static func buildBlock(_ children: Node...) -> [Node] { children }
    
    /// Flattens an array of arrays of nodes into a single array.
    ///
    /// - Parameter components: A variadic list of arrays of nodes.
    /// - Returns: A single flattened array containing all nodes.
    public static func buildBlock(_ components: [Node]...) -> [Node] { components.flatMap { $0 } }
    
    /// Flattens an array of arrays of nodes into a single array.
    ///
    /// - Parameter components: An array of arrays of nodes.
    /// - Returns: A single flattened array containing all nodes.
    public static func buildArray(_ components: [[Node]]) -> [Node] { components.flatMap { $0 } }
    
    /// Passes through an array of nodes as is.
    ///
    /// - Parameter components: An array of nodes.
    /// - Returns: The same array of nodes.
    public static func buildArray(_ components: [Node]) -> [Node] { components }
    
    /// Wraps a single node into an array.
    ///
    /// - Parameter expression: A single node.
    /// - Returns: An array containing the single node.
    public static func buildExpression(_ expression: Node) -> [Node] { [expression] }
    
    /// Handles optional nodes by returning an empty array if nil.
    ///
    /// - Parameter component: An optional array of nodes.
    /// - Returns: The array of nodes if present, otherwise an empty array.
    public static func buildOptional(_ component: [Node]?) -> [Node] { component ?? [] }
    
    /// Handles the first branch of a conditional statement.
    ///
    /// - Parameter component: The array of nodes for the first branch.
    /// - Returns: The array of nodes for the first branch.
    public static func buildEither(first component: [Node]) -> [Node] { component }
    
    /// Handles the second branch of a conditional statement.
    ///
    /// - Parameter component: The array of nodes for the second branch.
    /// - Returns: The array of nodes for the second branch.
    public static func buildEither(second component: [Node]) -> [Node] { component }
    
    /// Handles conditional inclusion of nodes.
    ///
    /// - Parameter component: An optional array of nodes.
    /// - Returns: The array of nodes if present, otherwise an empty array.
    public static func buildIf(_ component: [Node]?) -> [Node] { component ?? [] }
    
    /// Placeholder for switch statement handling; should not be called directly.
    ///
    /// - Parameter value: The value being switched on.
    /// - Returns: This method always triggers a fatal error.
    public static func buildSwitch<T>(_ value: T) -> [Node] where T: Equatable { fatalError("buildSwitch should not be called directly") }
}

extension FBuilder {
    /// Handles switch statements in the result builder by applying a builder closure.
    ///
    /// - Parameters:
    ///   - value: The value being switched on.
    ///   - builder: A closure that returns an array of nodes for the given value.
    /// - Returns: An array of nodes produced by the builder closure.
    public static func buildSwitch<T>(_ value: T, @FBuilder<Node> _ builder: (T) -> [Node]) -> [Node] where T: Equatable {
        builder(value)
    }
}
