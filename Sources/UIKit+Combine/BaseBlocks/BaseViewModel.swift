//
//  File.swift
//
//
//  Created by Duke Nguyen on 16/02/2024.
//

import Combine
import Foundation
import DesignCore

public protocol ViewModeling: AnyObject {
    var error: Error? { get set }
}

open class BaseViewModel: NSObject, ViewModeling, Loggable {
    @Published
    public var error: Error?
    open var cancellables = Set<AnyCancellable>()
    
    public required override init() {
        super.init()
        bind()
    }
    
    @objc dynamic open func bind() { }
    
    public func load<T: Codable>(target: inout T?, value: T) {
        target = value
    }
    
    public func load<T: Codable>(target: inout T, value: T) {
        target = value
    }
    
    public func handle(_ error: Error) {
        logger.error("Error found: \(error)")
        self.error = error
    }
    
    open func discardAll() {
        fatalError("\(String(describing: self)) didn't implemented discardAll()")
    }
    
    deinit {
        logger.trace("Deinitialized \(self)")
    }
}

