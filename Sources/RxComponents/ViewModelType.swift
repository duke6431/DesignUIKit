//
//  ViewModelType.swift
//  DesignRx
//
//  Created by Duc IT. Nguyen Minh on 07/01/2023.
//

import Foundation

public protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

public struct RxStatusPair {
    public var errorTracker = ErrorTracker()
    public var activityIndicator = ActivityIndicator()
    
    public init(errorTracker: ErrorTracker = ErrorTracker(), activityIndicator: ActivityIndicator = ActivityIndicator()) {
        self.errorTracker = errorTracker
        self.activityIndicator = activityIndicator
    }
}
