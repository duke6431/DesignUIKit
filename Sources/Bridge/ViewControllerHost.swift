//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 04/02/2024.
//

import SwiftUI
#if canImport(UIKit)
import UIKit

public extension UIViewController {
    static func hosted<ContentView: View>(
        _ contentView: ContentView,
        in navigationController: UINavigationController? = nil
    ) -> UIViewController {
        // Make the HostingController to use as an environment variable.
        // The (wrapped) view controller property can not be set yet.
        let hostingController = HostingController()
        
        // Make the UIHostingController instance. Inject environment variables into
        // the SwiftUI view for the containing UIHostingController and UINavigationController.
        let viewController = UIHostingController(rootView: contentView
            .environment(\.hostingController, hostingController)
            .environment(\.navigationController, navigationController)
        )
        
        // Now the UIHostingController has been instantiated. Update the
        // environment variable
        hostingController.viewController = viewController
        return viewController
    }
}

#elseif canImport(AppKit)
import AppKit

public extension NSViewController {
    static func hosted<ContentView: View>(
        _ contentView: ContentView,
        in navigationController: NSNavigationController? = nil
    ) -> NSViewController {
        // Make the HostingController to use as an environment variable.
        // The (wrapped) view controller property can not be set yet.
        let hostingController = HostingController()
        
        // Make the UIHostingController instance. Inject environment variables into
        // the SwiftUI view for the containing UIHostingController and UINavigationController.
        let viewController = NSHostingController(rootView: contentView
            .environment(\.hostingController, hostingController)
            .environment(\.navigationController, navigationController)
        )
        
        // Now the UIHostingController has been instantiated. Update the
        // environment variable
        hostingController.viewController = viewController
        return viewController
    }
}
#endif

