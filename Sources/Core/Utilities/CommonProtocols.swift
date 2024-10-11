//
//  CommonProtocols.swift
//  
//
//  Created by Duc Minh Nguyen on 5/17/22.
//

import Foundation

@resultBuilder
public enum FBuilder<Node> {
    public static func buildBlock() -> [Node] { [] }
    
    public static func buildBlock(_ children: Node...) -> [Node] { children }
    
    public static func buildBlock(_ components: [Node]...) -> [Node] { components.flatMap { $0 } }
    
    public static func buildArray(_ components: [[Node]]) -> [Node] { components.flatMap { $0 } }
    
    public static func buildArray(_ components: [Node]) -> [Node] { components }
    
    public static func buildExpression(_ expression: Node) -> [Node] { [expression] }
    
    public static func buildOptional(_ component: [Node]?) -> [Node] { component ?? [] }
    
    public static func buildEither(first component: [Node]) -> [Node] { component }
    
    public static func buildEither(second component: [Node]) -> [Node] { component }
    
    public static func buildIf(_ component: [Node]?) -> [Node] { component ?? [] }
    
    public static func buildSwitch<T>(_ value: T) -> [Node] where T: Equatable { fatalError("buildSwitch should not be called directly") }
}

extension FBuilder {
    public static func buildSwitch<T>(_ value: T, @FBuilder<Node> _ builder: (T) -> [Node]) -> [Node] where T: Equatable {
        builder(value)
    }
}
