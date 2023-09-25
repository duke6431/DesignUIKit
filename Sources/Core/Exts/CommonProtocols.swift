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
    public static func buildBlock(_ components: [T]...) -> [T] {
        components.flatMap { $0 }
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
}

public protocol ViewBuildable: ViewBuildableConvertible {
    var body: UIView { get }
}

extension ViewBuildable where Self: UIView {
    public var body: UIView { self }
}

public protocol ViewBuildableConvertible {
    func view() -> [ViewBuildable]
}

extension ViewBuildable {
    public func view() -> [ViewBuildable] { [self] }
}

extension Array: ViewBuildableConvertible where Element == ViewBuildable {
    public func view() -> [ViewBuildable] { self }
}

@resultBuilder
public struct ViewBuilder {
    public static func buildBlock(_ components: [ViewBuildable]) -> ViewBuildable {
        components.first!
    }

    public static func buildBlock() -> [ViewBuildable] {
        []
    }
    public static func buildBlock(_ components: ViewBuildable...) -> [ViewBuildable] {
        components
    }
    public static func buildBlock(_ components: ViewBuildableConvertible...) -> [ViewBuildable] {
        components.flatMap { $0.view() }
    }
    public static func buildOptional(_ component: ViewBuildableConvertible?) -> ViewBuildableConvertible {
        component ?? []
    }
    public static func buildEither(first component: ViewBuildableConvertible) -> ViewBuildableConvertible {
        component
    }
    public static func buildEither(second component: ViewBuildableConvertible) -> ViewBuildableConvertible {
        component
    }
}
