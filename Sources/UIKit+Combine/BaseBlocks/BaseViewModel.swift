//
//  File.swift
//
//
//  Created by Duke Nguyen on 16/02/2024.
//

import Combine
import Foundation
import DesignCore

@MainActor public protocol ViewModeling: AnyObject {
    var error: Error? { get set }

    func drain(with cancellables: inout Set<AnyCancellable>)
}

@MainActor open class BaseViewModel: NSObject, ViewModeling, Loggable {
    @Published
    public var error: Error?
    private var cancellables = Set<AnyCancellable>()

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

    public func drain(with cancellables: inout Set<AnyCancellable>) {
        self.cancellables.forEach { cancellables.insert($0) }
        self.cancellables = .init(minimumCapacity: 0)
    }
    
    deinit {
        logger.trace("Deinitialized \(self)")
    }
}

