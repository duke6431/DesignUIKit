//
//  File.swift
//
//
//  Created by Duc IT. Nguyen Minh on 17/02/2024.
//

import Foundation
import DesignCore
#if SWIFT_PACKAGE
import Toast
#else
import ToastViewSwift
#endif

public enum MPresentationStyle {
    case toast(dir: Toast.Direction)

    case sheet(dir: PanModal.OriginDirection)

    /// System UIAlertViewController/Customable
    case center
    ///
    case present
    case push

    case custom(_ presenter: MHandlerStyle)
}

public protocol MPresentable {
    var icon: UIImage? { get }
    var title: String? { get }
    var messageDescription: String? { get }
    var attributedTitle: NSAttributedString? { get }
    var attributedMessageDescription: NSAttributedString? { get }

    var actions: [MAction] { get }

    var presentationStyle: MPresentationStyle { get }
}

public extension MPresentable {
    var icon: UIImage? { nil }
    var title: String? { nil }
    var messageDescription: String? { nil }
    var attributedTitle: NSAttributedString? { nil }
    var attributedMessageDescription: NSAttributedString? { nil }

    var actions: [MAction] { [.ok] }

    var presentationStyle: MPresentationStyle { .center }
}

public protocol MHandlable {
    var viewController: UIViewController? { get }

    // TODO: 5 alert style: pop up, toast, drop down, bottom sheet, fullscreen
    // low: toast: just for show
    // medium: bottom sheet: show error and recoveries options
    // high: dropdown: just show error and maybe a dangerous recoveries options
    // unknown error: pop up: center in screen, nothing can be done here or fullscreen
    // The style should be configurable
    func handle(_ message: MPresentable)
}

public protocol MPresenter {
    func body(using message: MPresentable) -> FBodyComponent
}
