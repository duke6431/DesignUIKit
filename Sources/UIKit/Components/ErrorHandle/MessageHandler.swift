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
    
    public weak var navigationController: BNavigationController?
    
    var handlers: [MPresentationStyle: MHandlerStyle] = [
        .toast: MToastHandler.instance,
        .top: MSheetHandler.instance,
        .bottom: MSheetHandler.instance.updated(\.direction, with: .bottom),
        .center: MAlertHandler.instance,
        .fullscreen: MFullscreenHandler.instance
    ]
    
    public func handle(_ message: MPresentable) {
        guard let navigationController, let handler = handlers[message.presentationStyle] else { return }
        handler.handle(using: navigationController, with: message)
    }
}

public protocol MHandlerStyle {
    static var instance: Self { get }
    func handle(using navigationController: BNavigationController, with message: MPresentable)
}

public struct MToastHandler: MHandlerStyle, SelfCustomizable {
    public static var instance: MToastHandler { .init() }
    
    public func handle(using navigationController: BNavigationController, with message: MPresentable) {
        
    }
}

public struct MSheetHandler: MHandlerStyle, SelfCustomizable {
    public static var instance: MSheetHandler { .init() }
    
    var direction: PanModal.OriginDirection = .top
    
    public func handle(using navigationController: BNavigationController, with message: MPresentable) {
        navigationController.present(BViewController(), direction: direction)
    }
}

public struct MAlertHandler: MHandlerStyle {
    public static var instance: MAlertHandler { .init() }
    
    public func handle(using navigationController: BNavigationController, with message: MPresentable) {
        let alertController = UIAlertController(
            title: message.title,
            message: message.messageDescription,
            preferredStyle: .alert
        )
        message.actions.map { action in
            UIAlertAction(title: action.title, style: action.style.alertStyle) { _ in
                action.action?()
            }
        }.forEach(alertController.addAction(_:))
        navigationController.present(alertController, animated: true)
    }
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

public struct MFullscreenHandler: MHandlerStyle {
    public static var instance: MFullscreenHandler { .init() }
    
    public func handle(using navigationController: BNavigationController, with message: MPresentable) {
        navigationController.pushViewController(BViewController(), animated: true)
    }
}
