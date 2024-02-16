//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 16/02/2024.
//

import Combine
import Foundation

public protocol ViewModeling: AnyObject {
    var error: Error? { get set }
}

open class ViewModel: NSObject, ViewModeling {
    @Published
    public var error: Error?
    
    @MainActor
    public func load<T: Codable>(target: inout T?, value: T) {
        target = value
    }
    
    @MainActor
    public func load<T: Codable>(target: inout T, value: T) {
        target = value
    }
    
    @MainActor
    public func handle(_ error: Error) {
        self.error = error
    }
    
    open func discardAll() {
        fatalError("\(String(describing: self)) didn't implemented discardAll()")
    }
}
