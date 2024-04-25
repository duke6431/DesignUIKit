//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 17/02/2024.
//

import Foundation
import DesignCore

public enum MPresentationStyle {
    case toast
    case top
    case bottom
    case center
    case fullscreen
}

public protocol MPresentable {
    var icon: BImage? { get }
    var title: String? { get }
    var messageDescription: String? { get }
    var attributedTitle: NSAttributedString? { get }
    var attributedMessageDescription: NSAttributedString? { get }

    var actions: [MAction] { get }
    
    var presentationStyle: MPresentationStyle { get }
}

public extension MPresentable {
    var icon: BImage? { nil }
    var title: String? { nil }
    var messageDescription: String? { nil }
    var attributedTitle: NSAttributedString? { nil }
    var attributedMessageDescription: NSAttributedString? { nil }

    var actions: [MAction] { [.ok] }
    
    var presentationStyle: MPresentationStyle { .center }
}

public protocol MHandlable {
    var navigationController: BNavigationController? { get }
    
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
