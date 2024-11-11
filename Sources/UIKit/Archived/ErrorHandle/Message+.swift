//
//  File.swift
//
//
//  Created by Duc Minh Nguyen on 4/23/24.
//

import Foundation
import DesignCore

extension BaseCoordinator: MHandlable {
    public var viewController: UIViewController? { navigationController }
}

extension BaseCoordinating {
    public func handle(_ message: MPresentable) {
        MHandler.instance.with(\.viewController, setTo: navigationController).handle(message)
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
