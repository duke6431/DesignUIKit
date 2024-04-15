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
import SnapKit

public typealias FBinder<Subject> = AnyPublisher<Subject, Never>

public protocol Combinable: AnyObject {
    var cancellables: Set<AnyCancellable> { get set }
}

public protocol FComponent: AnyObject, Chainable, Combinable {
    var configuration: FConfiguration? { get }
    var layoutConfiguration: ((_ make: ConstraintMaker) -> Void)? { get set }
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
    @discardableResult func layout(_ layoutConfiguration: @escaping (_ make: ConstraintMaker) -> Void) -> Self {
        with(\.layoutConfiguration, setTo: layoutConfiguration)
    }
    
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

public enum FShape {
    case circle
    case roundedRectangle(cornerRadius: CGFloat, corners: BRectCorner = .allCorners)
}
