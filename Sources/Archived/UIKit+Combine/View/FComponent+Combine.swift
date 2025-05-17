//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 26/9/24.
//

import UIKit
import Combine
import DesignUIKit
import DesignCore

public typealias FBinder<Subject> = AnyPublisher<Subject, Never>

public protocol Combinable: AnyObject {
    var cancellables: Set<AnyCancellable> { get set }
}

extension UIView: Combinable {
    static let cancellables = ObjectAssociation<StructWrapper<Set<AnyCancellable>>>()
    
    public var cancellables: Set<AnyCancellable> {
        get {
            if let cancellables = Self.cancellables[self]?.value {
                return cancellables
            }
            let cancellables = Set<AnyCancellable>()
            Self.cancellables[self] = .init(value: cancellables)
            return cancellables
        }
        set { Self.cancellables[self] = .init(value: newValue) }
    }
}

public extension FComponent where Self: UIView, Self: Combinable {
    @discardableResult func bind<Subject, Failure>(
        to publisher: AnyPublisher<Subject, Failure>,
        next: @escaping (Self, Subject) -> Void,
        error: ((Failure) -> Void)? = nil,
        complete: (() -> Void)? = nil
    ) -> Self {
        publisher.receive(on: DispatchQueue.main).sink { completion in
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
