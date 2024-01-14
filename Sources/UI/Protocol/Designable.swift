//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 09/01/2024.
//

import SwiftUI

/// To use designable protocol via @Environment,
/// The FontSystem.shared and ThemeSystem.shared
/// must be observed at app level so when the value updated, everything will change accordingly
public protocol Designable {
    var spacingSystem: SpacingSystem { get }
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

public extension EnvironmentValues {
    var themeSystem: ThemeSystem {
        get { self[ThemeSystemKey.self] }
        set { self[ThemeSystemKey.self] = newValue }
    }
}

private struct SpacingSystemKey: EnvironmentKey {
    static let defaultValue = SpacingSystem.shared
}

public extension EnvironmentValues {
    var spacingSystem: SpacingSystem {
        get { self[SpacingSystemKey.self] }
        set { self[SpacingSystemKey.self] = newValue }
    }
}
