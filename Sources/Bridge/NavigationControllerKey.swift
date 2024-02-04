//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 04/02/2024.
//

import SwiftUI

/// `EnvironmentKey` to access the containing `UINavigationController`
public struct NavigationControllerKey: EnvironmentKey {
    
    #if canImport(UIKit)
    /// The `UINavigationController` instance
    public static let defaultValue: UINavigationController? = nil
    #elseif canImport(AppKit)
    /// The `NSNavigationController` instance
    public static let defaultValue: NSNavigationController? = nil
#endif
}

public extension EnvironmentValues {
#if canImport(UIKit)
    /// Get and set `UINavigationController` for `NavigationControllerKey`
    var navigationController: UINavigationController? {
        get { self[NavigationControllerKey.self] }
        set { self[NavigationControllerKey.self] = newValue }
    }
#elseif canImport(AppKit)
    /// Get and set `NSNavigationController` for `NavigationControllerKey`
    var navigationController: NSNavigationController? {
        get { self[NavigationControllerKey.self] }
        set { self[NavigationControllerKey.self] = newValue }
    }
#endif
}
