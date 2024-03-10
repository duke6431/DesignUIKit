//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import Combine
import DesignCore
import DesignExts

public protocol Combinable: AnyObject {
    var cancellables: Set<AnyCancellable> { get set }
}

public protocol FComponent: AnyObject, Chainable, Combinable {
    var configuration: FConfiguration? { get }
    var customConfiguration: ((Self) -> Void)? { get set }
}

public extension FComponent where Self: UIView, Self: Combinable {
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
    func huggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self
    @discardableResult
    func compressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self
}

public extension FContentConstraintable where Self: UIView {
    @discardableResult func huggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        setContentHuggingPriority(priority, for: axis)
        return self
    }
    
    @discardableResult func compressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        setContentCompressionResistancePriority(priority, for: axis)
        return self
    }
}

public protocol FContentAvailable: FContentConstraintable {
    @discardableResult func insets(_ insets: UIEdgeInsets) -> Self
    @discardableResult func insets(_ insets: CGFloat) -> Self
    @discardableResult func insets(_ edges: UIRectEdge, _ insets: CGFloat) -> Self
}

public extension FContentAvailable where Self: BaseLabel {
    @discardableResult func insets(_ insets: UIEdgeInsets) -> Self {
        contentInsets = contentInsets + insets
        return self
    }
    
    @discardableResult func insets(_ insets: CGFloat) -> Self {
        self.insets(.all, insets)
    }
    
    @discardableResult func insets(_ edges: UIRectEdge, _ insets: CGFloat) -> Self {
        contentInsets = contentInsets.add(edges, insets)
        return self
    }
}

public protocol FStylable: AnyObject, Chainable {
    @discardableResult func font(_ font: UIFont) -> Self
    @discardableResult func foreground(_ color: UIColor) -> Self
}

public extension FStylable where Self: UILabel {
    @discardableResult func font(_ font: UIFont = FontSystem.shared.font(with: .body)) -> Self {
        with(\.font, setTo: font)
    }

    @discardableResult func foreground(_ color: UIColor = .label) -> Self {
        with(\.textColor, setTo: color)
    }
}

public extension FStylable where Self: UIButton {
    @discardableResult func font(_ font: UIFont = FontSystem.shared.font(with: .body)) -> Self {
        titleLabel?.with(\.font, setTo: font)
        return self
    }

    @discardableResult func foreground(_ color: UIColor = .label) -> Self {
        setTitleColor(color, for: .normal)
        return self
    }
}

public enum FShape {
    case circle
    case roundedRectangle(cornerRadius: CGFloat, corners: UIRectCorner = .allCorners)
}
