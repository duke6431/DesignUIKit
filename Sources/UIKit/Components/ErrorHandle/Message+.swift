//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 4/23/24.
//

import Foundation

extension BaseCoordinator: MHandlable {
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
        guard let coordinator = baseCoordinating as? BaseCoordinator, let error = error as? MPresentable else { return }
        coordinator.handle(error)
    }
}
