//
//  RxGeneric+.swift
//  DesignKitRx
//
//  Created by Duc IT. Nguyen Minh on 06/01/2023.
//

import RxSwift
import RxCocoa

public extension ObservableType where Element == Bool {
    /// Boolean not operator
    func not() -> Observable<Bool> {
        map { !$0 }
    }
}

public extension ObservableType {
    func catchErrorJustComplete() -> Observable<Element> { `catch` { _ in .empty() } }

    func asDriverOnErrorJustComplete() -> Driver<Element> { asDriver { _ in .empty() } }

    func void() -> Observable<Void> { map { _ in } }
}

public extension SharedSequence {
    func void() -> SharedSequence<SharingStrategy, Void> { map { _ in () } }
}
