//
//  RxGeneric+.swift
//  DesignRx
//
//  Created by Duc IT. Nguyen Minh on 06/01/2023.
//

import RxSwift
import RxCocoa

public extension ObservableType where Element == Bool {
    /// Boolean not operator
    func not() -> Observable<Bool> {
        map { !value }
    }
}

public extension ObservableType {
    func catchErrorJustComplete() -> Observable<Element> {
        catchError { _ in Observable.empty() }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        asDriver { _ in Driver.empty() }
    }
    
    func mapToVoid() -> Observable<Void> {
        map { _ in }
    }
}

public extension SharedSequence {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> { map { _ in () } }
}
