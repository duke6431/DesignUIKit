//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 04/02/2024.
//

import SwiftUI

public final class HostingController {
#if canImport(UIKit)
    public weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
#elseif canImport(AppKit)
    public weak var viewController: NSViewController?
    
    init(viewController: NSViewController? = nil) {
        self.viewController = viewController
    }
#endif
}

/// `EnvironmentKey` to access the containing `UIViewController`
public struct HostingControllerKey: EnvironmentKey {
    
    /// The `HostingController` instance
    public static let defaultValue: HostingController? = nil
}

public extension EnvironmentValues {
    
    /// Get and set `UIViewController` for `HostingControllerKey`
    var hostingController: HostingController? {
        get { self[HostingControllerKey.self] }
        set { self[HostingControllerKey.self] = newValue }
    }
}
