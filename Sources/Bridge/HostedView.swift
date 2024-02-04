//
//  HostedView.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 04/02/2024.
//

import SwiftUI

/// A SwiftUI `View` that is the root of a `UIHostingController`
public protocol HostedView: View {
    
    /// Get the hosted `UIViewController`
    var hostingController: HostingController? { get }
    
    /// Get the container `UINavigationController`
    var navigationController: UINavigationController? { get }
}

public extension HostedView {
    
    /// By default, return `nil`
    var hostingController: HostingController? {
        nil
    }
    
    /// By default, return `nil`
    var navigationController: UINavigationController? {
        nil
    }
}
