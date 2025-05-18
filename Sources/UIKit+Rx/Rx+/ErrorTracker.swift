//
//  ErrorTracker.swift
//  DesignRxUIKit
//
//  Created by Duke Nguyen on 2024/11/13.
//
//  A utility for tracking and forwarding errors through a reactive stream.
//  Supports integration with RxSwift and Driver-based reactive chains.
//

import Foundation
import RxSwift
import RxCocoa

/// Tracks errors in reactive chains and exposes them as `Driver`, `Observable`, or `SharedSequence`.
/// Commonly used to monitor and handle errors in RxSwift flows.
public final class ErrorTracker: SharedSequenceConvertibleType {
    public typealias SharingStrategy = DriverSharingStrategy
    /// The internal subject that relays tracked errors to observers.
    private let _subject = PublishSubject<Error>()
    public var forceErrorSubject : PublishSubject<Error> { _subject }
    
    public init() { }
    
    /// Tracks errors emitted from an `ObservableConvertibleType`.
    /// - Parameter source: The observable to monitor.
    /// - Returns: An observable or driver that emits the same elements and relays errors to the tracker.
    func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        source.asObservable().do(onError: onError)
    }
    
    /// Tracks errors emitted from an `ObservableConvertibleType`.
    /// - Parameter source: The observable to monitor.
    /// - Returns: An observable or driver that emits the same elements and relays errors to the tracker.
    func trackError<O: ObservableConvertibleType>(from source: O) -> Driver<O.Element> {
        source.asObservable().do(onError: onError).completeDriver()
    }
    
    /// Exposes the tracked errors as a stream in the desired reactive form.
    public func asDriver() -> Driver<Error> {
        _subject.completeDriver()
    }
    
    /// Exposes the tracked errors as a stream in the desired reactive form.
    public func asSharedSequence() -> SharedSequence<SharingStrategy, Error> {
        _subject.completeDriver()
    }
    
    /// Exposes the tracked errors as a stream in the desired reactive form.
    public func asObservable() -> Observable<Error> {
        _subject.asObservable()
    }
    
    /// Relays the error to the internal subject.
    /// - Parameter error: The error to track.
    private func onError(_ error: Error) {
        _subject.onNext(error)
    }
    
    /// Completes the internal subject upon deinitialization to release resources.
    deinit {
        _subject.onCompleted()
    }
}

public extension ObservableConvertibleType {
    /// Extension to allow any observable to be tracked via an `ErrorTracker`.
    
    /// Tracks errors from the observable using the given `ErrorTracker`.
    /// - Parameter errorTracker: The tracker to relay errors to.
    /// - Returns: An observable or driver with error tracking applied.
    func trackError(_ errorTracker: ErrorTracker) -> Observable<Element> {
        return errorTracker.trackError(from: self)
    }
    
    /// Tracks errors from the observable using the given `ErrorTracker`.
    /// - Parameter errorTracker: The tracker to relay errors to.
    /// - Returns: An observable or driver with error tracking applied.
    func trackError(_ errorTracker: ErrorTracker) -> Driver<Element> {
        return errorTracker.trackError(from: self)
    }
}
