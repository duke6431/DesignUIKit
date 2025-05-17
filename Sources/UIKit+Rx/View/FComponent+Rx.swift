//
//  FComponent+Rx.swift
//  DesignRxUIKit
//
//  Created by Duke Nguyen on 2024/09/26.
//
//  Adds reactive support to UI components with `Reactivable` protocol,
//  providing a `disposeBag` and a `bind` method to subscribe to RxSwift streams.
//

import UIKit
import RxSwift
import DesignUIKit
import DesignCore
import RxCocoa

/// A protocol for UI components that should support RxSwift subscriptions via a `DisposeBag`.
public protocol Reactivable: AnyObject {
    /// The `DisposeBag` used to store subscriptions tied to the component's lifecycle.
    var disposeBag: DisposeBag { get set }
}

/// Conforms all `UIView` instances to `Reactivable` using associated objects to manage the `DisposeBag`.
extension UIView: Reactivable {
    static let disposeBag = ObjectAssociation<DisposeBag>()
    
    /// Lazily initializes and retrieves the associated `DisposeBag` for the view.
    public var disposeBag: DisposeBag {
        get {
            if let disposeBag = Self.disposeBag[self] { return disposeBag }
            let disposeBag = DisposeBag()
            Self.disposeBag[self] = disposeBag
            return disposeBag
        }
        set { Self.disposeBag[self] = newValue }
    }
}

public extension FComponent where Self: UIView, Self: Reactivable {
    /// Binds a `Driver` to the component using a provided update closure.
    ///
    /// - Parameters:
    ///   - publisher: The `Driver` that emits values to be bound.
    ///   - next: A closure that applies the emitted value to `self`.
    ///   - error: An optional closure called if an error is tracked.
    ///   - complete: An optional closure called when the stream completes.
    /// - Returns: Self for chaining.
    @discardableResult func bind<Subject>(
        to publisher: Driver<Subject>,
        next: @escaping (Self, Subject) -> Void,
        error: ((Error) -> Void)? = nil,
        complete: (() -> Void)? = nil
    ) -> Self {
        let localET = ErrorTracker()
        disposeBag.insert {
            publisher.trackError(localET).drive { [weak self] in
                guard let self = self else { return }
                next(self, $0)
            } onCompleted: { complete?() }
            localET.drive(onNext: error)
        }
        return self
    }
}
