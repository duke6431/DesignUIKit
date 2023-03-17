//
//  ErrorTracker.swift
//  DesignRx
//
//  Created by Duc IT. Nguyen Minh on 07/01/2023.
//

import RxSwift
import RxCocoa

public class ErrorTracker: SharedSequenceConvertibleType {
    public typealias SharingStrategy = DriverSharingStrategy
    private let _subject = PublishSubject<Error>()

    public func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        return source.asObservable().do(onError: onError)
    }

    public func asSharedSequence() -> SharedSequence<SharingStrategy, Error> {
        return _subject.asObservable().asDriver { _ in return Driver.empty() }
    }

    public func asObservable() -> Observable<Error> {
        return _subject.asObservable()
    }

    public func onError(_ error: Error) {
        _subject.onNext(error)
    }

    public init() { }

    deinit { _subject.onCompleted() }
}

extension ObservableConvertibleType {
    public func track(_ errorTracker: ErrorTracker) -> Observable<Element> {
        return errorTracker.trackError(from: self)
    }
}
