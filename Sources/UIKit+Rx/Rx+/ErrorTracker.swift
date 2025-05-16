//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 13/11/24.
//

import Foundation
import RxSwift
import RxCocoa

public final class ErrorTracker: SharedSequenceConvertibleType {
    public typealias SharingStrategy = DriverSharingStrategy
    private let _subject = PublishSubject<Error>()
    
    func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        source.asObservable().do(onError: onError)
    }
    
    func trackError<O: ObservableConvertibleType>(from source: O) -> Driver<O.Element> {
        source.asObservable().do(onError: onError).completeDriver()
    }
    
    public func asDriver() -> Driver<Error> {
        _subject.completeDriver()
    }
    
    public func asSharedSequence() -> SharedSequence<SharingStrategy, Error> {
        _subject.completeDriver()
    }
    
    public func asObservable() -> Observable<Error> {
        _subject.asObservable()
    }
    
    private func onError(_ error: Error) {
        _subject.onNext(error)
    }
    
    deinit {
        _subject.onCompleted()
    }
}

public extension ObservableConvertibleType {
    func trackError(_ errorTracker: ErrorTracker) -> Observable<Element> {
        return errorTracker.trackError(from: self)
    }
    
    func trackError(_ errorTracker: ErrorTracker) -> Driver<Element> {
        return errorTracker.trackError(from: self)
    }
}
