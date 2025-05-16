//
//  Combine+.swift
//  componentsystem
//
//  Created by Duc Minh Nguyen on 4/2/24.
//

import Foundation
import Combine

public extension Publisher {
    func compacted<T>() -> Publishers.CompactMap<Self, T> where Output == Optional<T> {
        compactMap { $0 }
    }
    
    func void() -> Publishers.Map<Self, Void> {
        map { _ in }
    }
    
    func toggle() -> Publishers.Map<Self, Output> where Output == Bool {
        map { !$0 }
    }
}

public extension Publisher {
    func invertFilter(_ isIncluded: @escaping (Self.Output) -> Bool) -> Publishers.Filter<Self> {
        filter { !isIncluded($0) }
    }
    
    func match(_ value: Output) -> Publishers.CompactMap<Self, Output> where Output: Equatable {
        compactMap { $0 == value ? value : nil }
    }
}

public extension Publisher {
    func cast<T>(to kind: T.Type) -> Publishers.CompactMap<Self, T> {
        compactMap { $0 as? T }
    }
    
    func optionalCast<T>(to kind: T.Type) -> Publishers.Map<Self, T?> {
        map { $0 as? T }
    }
}

public extension Publisher {
    func erased() -> AnyPublisher<Output, Failure> {
        eraseToAnyPublisher()
    }
    
    func sink(_ receiveValue: (() -> Void)? = nil) -> AnyCancellable where Output == Void, Failure == Never {
        sink(receiveValue: receiveValue ?? { })
    }
    
    func sink(_ receiveValue: ((Output) -> Void)? = nil) -> AnyCancellable where Failure == Never {
        sink(receiveValue: receiveValue ?? { _ in })
    }
}
