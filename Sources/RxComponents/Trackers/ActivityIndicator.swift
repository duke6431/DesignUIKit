//
//  ActivityIndicator.swift
//  DesignKitRx
//
//  Created by Duc IT. Nguyen Minh on 06/01/2023.
//

import Foundation
import RxSwift
import RxCocoa

public class ActivityIndicator: SharedSequenceConvertibleType {
    public typealias Element = Bool
    public typealias SharingStrategy = DriverSharingStrategy

    private let lock = NSRecursiveLock()
    private let behavior = BehaviorRelay<Bool>(value: false)
    private let loading: SharedSequence<SharingStrategy, Bool>

    public init() {
        loading = behavior.asDriver()
            .distinctUntilChanged()
    }

    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.Element> {
        source.asObservable().do(
            onNext: { [sendStopLoading] _ in sendStopLoading() },
            onError: { [sendStopLoading] _ in sendStopLoading() },
            onCompleted: sendStopLoading,
            onSubscribe: subscribed
        )
    }

    private func subscribed() {
        lock.lock()
        behavior.accept(true)
        lock.unlock()
    }

    private func sendStopLoading() {
        lock.lock()
        behavior.accept(false)
        lock.unlock()
    }

    public func asSharedSequence() -> SharedSequence<SharingStrategy, Element> { loading }
}

extension ObservableConvertibleType {
    public func track(_ activityIndicator: ActivityIndicator) -> Observable<Element> {
        activityIndicator.trackActivityOfObservable(self)
    }
}
