//
//  CommonProtocols.swift
//  
//
//  Created by Duc Minh Nguyen on 5/17/22.
//

import UIKit

public protocol Renderable {
    func render() -> UIView
}

@resultBuilder
public struct BuilderComponent<T> {
    public static func buildBlock(_ components: T...) -> [T] {
        components
    }
    public static func buildArray(_ components: [T]) -> [T] {
        components
    }
    public static func buildOptional(_ component: T?) -> [T] {
        guard let component = component else {
            return []
        }
        return [component]
    }
    public static func buildEither(first components: [T]) -> [T] {
        components
    }
    public static func buildEither(second components: [T]) -> [T] {
        components
    }
    public static func buildArray(_ components: [[T]]) -> [T] {
        components.flatMap { $0 }
    }
    public static func buildBlock(_ components: [T]...) -> [T] {
        components.flatMap { $0 }
    }
}
