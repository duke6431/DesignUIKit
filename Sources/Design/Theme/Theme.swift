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
    // swiftlint:disable:next identifier_name
    static var _sharedProvider: ThemeProvider?
    public private(set) var palette: Palette

    public static func initialize(with bundle: Bundle?, and palette: Palette) {
        Theme.bundle = bundle ?? .main
        _sharedProvider = DefaultThemeProvider(with: .init(palette: palette))
    }

    public init(palette: Palette) {
        self.palette = palette
        if ColorLoader(container: palette).load() {
#if canImport(LoggerCenter)
            LogCenter.default.verbose("Successfully loaded palette \(palette.name)")
#endif
        } else {
#if canImport(LoggerCenter)
            LogCenter.default.verbose("Failure occurred while loading palette \(palette.name)")
#endif
        }
    }
}

public extension Theme {
    static var provider: ThemeProvider {
        guard let provider = _sharedProvider else {
            fatalError("Must run Theme.initialize(with:and:) before using provider")
        }
        return provider
    }
}
