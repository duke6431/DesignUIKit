//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif
import Combine
import DesignCore
import DesignExts

public typealias FBinder<Subject> = AnyPublisher<Subject, Never>

public protocol Combinable: AnyObject {
    var cancellables: Set<AnyCancellable> { get set }
}

public protocol FComponent: AnyObject, Chainable, Combinable {
    var configuration: FConfiguration? { get }
    var customConfiguration: ((Self) -> Void)? { get set }
}

public extension FComponent where Self: BView, Self: Combinable {
    @discardableResult func bind<Subject, Failure>(
        to publisher: AnyPublisher<Subject, Failure>,
        next: @escaping (Self, Subject) -> Void,
        error: ((Failure) -> Void)? = nil,
        complete: (() -> Void)? = nil
    ) -> Self {
        publisher.sink { completion in
            switch completion {
            case .failure(let failure):
                error?(failure)
            case .finished:
                complete?()
            }
        } receiveValue: { [weak self] subject in
            guard let self = self else { return }
            next(self, subject)
        }.store(in: &cancellables)
        return self
    }
}

public extension FComponent {
    @discardableResult func customConfiguration(_ configuration: ((Self) -> Void)?) -> Self {
        with(\.customConfiguration, setTo: configuration)
    }
}

public protocol FContentConstraintable: AnyObject {
    @discardableResult
    func huggingPriority(_ priority: BLayoutPriority, for axis: BAxis) -> Self
    @discardableResult
    func compressionResistancePriority(_ priority: BLayoutPriority, for axis: BAxis) -> Self
}

public extension FContentConstraintable where Self: BView {
    @discardableResult func huggingPriority(_ priority: BLayoutPriority, for axis: BAxis) -> Self {
        setContentHuggingPriority(priority, for: axis)
        return self
    }
    
    @discardableResult func compressionResistancePriority(_ priority: BLayoutPriority, for axis: BAxis) -> Self {
        setContentCompressionResistancePriority(priority, for: axis)
        return self
    }
}

public protocol FContentAvailable: FContentConstraintable {
    @discardableResult func insets(_ insets: BEdgeInsets) -> Self
    @discardableResult func insets(_ insets: CGFloat) -> Self
    @discardableResult func insets(_ edges: BRectEdge, _ insets: CGFloat) -> Self
}

public extension FContentAvailable where Self: BaseLabel {
    @discardableResult func insets(_ insets: BEdgeInsets) -> Self {
        contentInsets = contentInsets + insets
        return self
    }
    
    @discardableResult func insets(_ insets: CGFloat) -> Self {
        self.insets(.all, insets)
    }
    
    @discardableResult func insets(_ edges: BRectEdge, _ insets: CGFloat) -> Self {
        contentInsets = contentInsets.add(edges, insets)
        return self
    }
}

@objc public protocol FStylable: AnyObject, Chainable {
    @discardableResult @objc optional func font(_ font: BFont) -> Self
    @discardableResult func foreground(_ color: BColor) -> Self
}

public protocol FThemableForeground: Themable {
    var foregroundKey: ThemeKey? { get set }
    @discardableResult func foreground(_ color: BColor) -> Self
}

public protocol FThemableBackground: Themable {
    var backgroundKey: ThemeKey? { get set }
    @discardableResult func background(_ key: ThemeKey) -> Self
}

extension FThemableBackground {
    @discardableResult
    public func background(_ key: ThemeKey) -> Self {
        backgroundKey = key
        ThemeSystem.shared.register(observer: self)
        return self
    }
}

extension FThemableForeground {
    @discardableResult
    public func foreground(_ key: ThemeKey) -> Self {
        foregroundKey = key
        ThemeSystem.shared.register(observer: self)
        return self
    }
}

public enum FShape {
    case circle
    case roundedRectangle(cornerRadius: CGFloat, corners: BRectCorner = .allCorners)
}
