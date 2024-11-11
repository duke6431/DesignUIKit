//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 22/10/24.
//

import RxSwift
import RxCocoa

public extension Observable {
    func cast<T>(to type: T.Type) -> Observable<T> { compactMap { $0 as? T } }
    func void() -> Observable<Void> { map { _ in } }
    func compacted<T>() -> Observable<T> where Element == T? { compactMap { $0 } }
    func toggle() -> Observable<Bool> where Element == Bool { map { !$0 } }
    func infallibleDriver() -> Driver<Element> { asDriver(onErrorDriveWith: .never()) }
    func invertFilter(_ predicate: @escaping (Element) throws -> Bool) -> Observable<Element> { filter { try !predicate($0) } }
}

public extension Infallible {
    func cast<T>(to type: T.Type) -> Infallible<T> { compactMap { $0 as? T } }
    func void() -> Infallible<Void> { map { _ in } }
    func compacted<T>() -> Infallible<T> where Element == T? { compactMap { $0 } }
    func toggle() -> Infallible<Bool> where Element == Bool { map { !$0 } }
    func invertFilter(_ predicate: @escaping (Element) -> Bool) -> Infallible<Element> { filter { !predicate($0) } }
}

public extension SharedSequence {
    func cast<T>(to type: T.Type) -> SharedSequence<SharingStrategy, T> { compactMap { $0 as? T } }
    func void() -> SharedSequence<SharingStrategy, Void> { map { _ in } }
    func compacted<T>() -> SharedSequence<SharingStrategy, T> where Element == T? { compactMap { $0 } }
    func toggle() -> SharedSequence<SharingStrategy, Bool> where Element == Bool { map { !$0 } }
    func invertFilter(_ predicate: @escaping (Element) -> Bool) -> SharedSequence<SharingStrategy, Element> {
        filter { !predicate($0) }
    }
}
