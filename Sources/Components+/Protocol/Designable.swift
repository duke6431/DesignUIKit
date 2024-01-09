//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 09/01/2024.
//

import SwiftUI

public protocol Designable {
    var fontSystem: FontSystem { get }
    var themeSystem: ThemeSystem { get }
}

private struct FontSystemKey: EnvironmentKey {
    static let defaultValue = FontSystem.shared
}

public extension EnvironmentValues {
    var fontSystem: FontSystem {
        get { self[FontSystemKey.self] }
        set { self[FontSystemKey.self] = newValue }
    }
}

private struct ThemeSystemKey: EnvironmentKey {
    static let defaultValue = ThemeSystem.shared
}

extension EnvironmentValues {
    var themeSystem: ThemeSystem {
        get { self[ThemeSystemKey.self] }
        set { self[ThemeSystemKey.self] = newValue }
    }
}

