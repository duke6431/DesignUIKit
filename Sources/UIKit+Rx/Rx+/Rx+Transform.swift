//
//  Rx+Transform.swift
//  DesignRxUIKit
//
//  Created by Duke Nguyen on 2024/10/22.
//
//  A collection of RxSwift utility extensions that enhance
//  `Observable`, `Infallible`, and `SharedSequence` with
//  common transformations and helpers.
//

import RxSwift
import RxCocoa

public extension Observable {
    /// Casts elements to a specific type using `as?`.
    /// - Parameter type: The target type to cast to.
    /// - Returns: A stream of successfully cast elements.
    func cast<T>(to type: T.Type) -> Observable<T> { compactMap { $0 as? T } }
    
    /// Transforms the stream to emit `Void` for each element.
    /// - Returns: A stream of `Void` values.
    func void() -> Observable<Void> { map { _ in } }
    
    /// Filters out `nil` values from a stream of optionals.
    /// - Returns: A stream of non-nil unwrapped elements.
    func compacted<T>() -> Observable<T> where Element == T? { compactMap { $0 } }
    
    /// Toggles each emitted Boolean value.
    /// - Returns: A stream of inverted Boolean values.
    func toggle() -> Observable<Bool> where Element == Bool { map { !$0 } }
    
    /// Converts an observable to a driver that never errors by using `.never()` on failure.
    /// - Returns: A non-failing `Driver`.
    func infallibleDriver() -> Driver<Element> { asDriver(onErrorDriveWith: .never()) }
    
    /// Filters elements for which the predicate returns `false`.
    /// - Parameter predicate: A Boolean condition to invert.
    /// - Returns: A stream of elements that do not match the predicate.
    func invertFilter(_ predicate: @escaping (Element) throws -> Bool) -> Observable<Element> { filter { try !predicate($0) } }
}

public extension Infallible {
    /// Casts elements to a specific type using `as?`.
    /// - Parameter type: The target type to cast to.
    /// - Returns: A stream of successfully cast elements.
    func cast<T>(to type: T.Type) -> Infallible<T> { compactMap { $0 as? T } }
    
    /// Transforms the stream to emit `Void` for each element.
    /// - Returns: A stream of `Void` values.
    func void() -> Infallible<Void> { map { _ in } }
    
    /// Filters out `nil` values from a stream of optionals.
    /// - Returns: A stream of non-nil unwrapped elements.
    func compacted<T>() -> Infallible<T> where Element == T? { compactMap { $0 } }
    
    /// Toggles each emitted Boolean value.
    /// - Returns: A stream of inverted Boolean values.
    func toggle() -> Infallible<Bool> where Element == Bool { map { !$0 } }
    
    /// Filters elements for which the predicate returns `false`.
    /// - Parameter predicate: A Boolean condition to invert.
    /// - Returns: A stream of elements that do not match the predicate.
    func invertFilter(_ predicate: @escaping (Element) -> Bool) -> Infallible<Element> { filter { !predicate($0) } }
}

public extension ObservableConvertibleType {
    /// Converts the stream to a `Driver` that completes silently on error.
    /// - Returns: A `Driver` that emits values and completes silently if an error occurs.
    func completeDriver() -> Driver<Element> { asDriver(onErrorDriveWith: .empty()) }
}

public extension SharedSequence {
    /// Casts elements to a specific type using `as?`.
    /// - Parameter type: The target type to cast to.
    /// - Returns: A stream of successfully cast elements.
    func cast<T>(to type: T.Type) -> SharedSequence<SharingStrategy, T> { compactMap { $0 as? T } }
    
    /// Transforms the stream to emit `Void` for each element.
    /// - Returns: A stream of `Void` values.
    func void() -> SharedSequence<SharingStrategy, Void> { map { _ in } }
    
    /// Filters out `nil` values from a stream of optionals.
    /// - Returns: A stream of non-nil unwrapped elements.
    func compacted<T>() -> SharedSequence<SharingStrategy, T> where Element == T? { compactMap { $0 } }
    
    /// Toggles each emitted Boolean value.
    /// - Returns: A stream of inverted Boolean values.
    func toggle() -> SharedSequence<SharingStrategy, Bool> where Element == Bool { map { !$0 } }
    
    /// Filters elements for which the predicate returns `false`.
    /// - Parameter predicate: A Boolean condition to invert.
    /// - Returns: A stream of elements that do not match the predicate.
    func invertFilter(_ predicate: @escaping (Element) -> Bool) -> SharedSequence<SharingStrategy, Element> {
        filter { !predicate($0) }
    }
}
