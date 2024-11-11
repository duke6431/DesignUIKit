//
//  File.swift
//
//
//  Created by Duc Minh Nguyen on 4/23/24.
//

import Foundation
import DesignCore
import UIKit

public class MHandler: MHandlable, Chainable {
    public static var instance: MHandler { .init() }

    public weak var viewController: UIViewController?

    public func handle(_ message: MPresentable) {
        guard let viewController else { return }
        var handler: MHandlerStyle
        switch message.presentationStyle {
        case .toast(let dir):
            handler = MToastHandler().updated(\.direction, with: dir)
        case .sheet(let dir):
            handler = MSheetHandler().updated(\.direction, with: dir)
        case .center:
            handler = MAlertHandler()
        case .present:
            handler = MPresentHander()
        case .push:
            handler = MPushHandler()
        case .custom(let style):
            handler = style
        }
        handler.handle(using: viewController, with: message)
    }
}

public protocol MHandlerStyle {
    static var instance: Self { get }
    func handle(using viewComtroller: UIViewController, with message: MPresentable)
}

extension MActionStyle {
    var alertStyle: UIAlertAction.Style {
        switch self {
        case .default, .recover:
            return .default
        case .destructive:
            return .destructive
        case .cancel:
            return .cancel
        }
    }
}
