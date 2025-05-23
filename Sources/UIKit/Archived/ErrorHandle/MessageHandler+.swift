//
//  File.swift
//  
//
//  Created by Duke Nguyen on 8/31/24.
//

import Foundation
import DesignCore
import UIKit
#if SWIFT_PACKAGE
import Toast
#else
import ToastViewSwift
#endif

// TODO: Handle Toast Messages
public struct MToastHandler: MHandlerStyle, SelfCustomizable {
    public static var instance: MToastHandler { .init() }
    
    public var direction: Toast.Direction = .top
    
    public func handle(using viewComtroller: UIViewController, with message: MPresentable) {
        guard let title = message.title ?? message.messageDescription else { return }
        let titleAvailable = message.title != nil
        if let icon = message.icon {
            Toast.default(image: icon, title: title, subtitle: titleAvailable ? message.messageDescription : nil, config: .init(direction: direction)).show()
        } else {
            Toast.text(title, subtitle: titleAvailable ? message.messageDescription : nil, config: .init(direction: direction)).show()
        }
    }
}

public struct MSheetHandler: MHandlerStyle, SelfCustomizable {
    public static var instance: MSheetHandler { .init() }
    
    var content: ((MPresentable) -> FBodyComponent)?
    var direction: PanModal.OriginDirection = .bottom
    
    public func handle(using viewController: UIViewController, with message: MPresentable) {
        guard let content else { return }
        viewController.present(
            FViewContainer { content(message) },
            direction: direction
        )
    }
}

public struct MAlertHandler: MHandlerStyle {
    public static var instance: MAlertHandler { .init() }
    
    public func handle(using viewController: UIViewController, with message: MPresentable) {
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
        viewController.present(alertController, animated: true)
    }
}

public struct MPresentHander: MHandlerStyle {
    public static var instance: MPresentHander { .init() }
    
    public func handle(using viewController: UIViewController, with message: MPresentable) {
        viewController.present(UIViewController(), animated: true)
    }
}

public struct MPushHandler: MHandlerStyle {
    public static var instance: MPushHandler { .init() }
    
    public func handle(using viewController: UIViewController, with message: MPresentable) {
        guard let navigationController = viewController as? UINavigationController else { return }
        navigationController.pushViewController(UIViewController(), animated: true)
    }
}
