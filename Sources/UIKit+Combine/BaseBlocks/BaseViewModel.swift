//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 16/02/2024.
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
    
    deinit {
#if COMPONENT_SYSTEM_DBG
        logger.info("Deinitialized \(self)")
#endif
    }
}
