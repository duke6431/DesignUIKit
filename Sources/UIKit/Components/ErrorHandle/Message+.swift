//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 4/23/24.
//

import Foundation

extension BaseCoordinator: MHandlable { }

extension BaseCoordinating {
    public func handle(_ message: MPresentable) {
        MHandler.instance.with(\.navigationController, setTo: navigationController).handle(message)
    }
}

public protocol ErrorHandlable {
    var baseCoordinating: BaseCoordinating? { get }
    func handle(_ error: Error)
}

public extension ErrorHandlable {
    func handle(_ error: Error) {
        guard let baseCoordinating, let error = error as? MPresentable else { return }
        baseCoordinating.handle(error)
    }
}
