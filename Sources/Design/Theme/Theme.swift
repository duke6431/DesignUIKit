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
    static var bundle: Bundle = Bundle.main
    static var _sharedProvider: ThemeProvider?
    public private(set) var colorPalette: ColorPalette

    public static func initialize(with bundle: Bundle?, and theme: Theme) {
        Theme.bundle = bundle ?? .main
        _sharedProvider = DefaultThemeProvider(with: theme)
    }
    
    public init(colorPalette: ColorPalette) {
        self.colorPalette = colorPalette
    }
}

public extension Theme {
    static var provider: ThemeProvider {
        get {
            guard let provider = _sharedProvider else {
                fatalError("Must run Theme.initialize(with:and:) before using provider")
            }
            return provider
        }
    }
}
