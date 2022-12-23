//
//  Theme.swift
//  Core
//
//  Created by Duc Minh Nguyen on 11/5/21.
//

import UIKit
import SwiftUI
import DesignCore

public protocol Themable: AnyObject {
    var currentTheme: Theme? { get }
    func apply(theme: Theme)
}

public class Theme: NSObject {
    public enum `Type` {
        case light
        case dark
        @available(iOS 13.0, *)
        case adaptive
    }

    static let light: Theme = Theme(type: .light, colorPalette: .light)
    static let dark: Theme = Theme(type: .dark, colorPalette: .dark)
    @available(iOS 13.0, *)
    static let adaptive: Theme = Theme(type: .adaptive, colorPalette: .adaptive)

    let type: `Type`
    public private(set) var colorPalette: ColorPalette

    init(type: Theme.`Type`, colorPalette: ColorPalette) {
        self.type = type
        self.colorPalette = colorPalette
    }
}
