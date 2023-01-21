//
//  ViewModelType.swift
//  DesignRx
//
//  Created by Duc IT. Nguyen Minh on 07/01/2023.
//

import Foundation
import RxSwift

public protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

public class RxStatusPair {
    public var errorTracker = ErrorTracker()
    public var activityIndicator = ActivityIndicator()
    
    public init(errorTracker: ErrorTracker = ErrorTracker(), activityIndicator: ActivityIndicator = ActivityIndicator()) {
        self.errorTracker = errorTracker
        self.activityIndicator = activityIndicator
    }
}

extension ObservableConvertibleType {
    func track(_ pair: RxStatusPair) -> Observable<Element> {
        track(pair.activityIndicator).track(pair.errorTracker)
    }
}
