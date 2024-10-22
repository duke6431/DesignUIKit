//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 19/10/24.
//

import UIKit
import DesignCore

public final class FBarButton: UIBarButtonItem, Chainable, FAssignable {
    public convenience init(_ view: FBody, action: (() -> Void)? = nil) {
        self.init(
            customView: FButton(label: view, action: action)
                .layoutPriority(.high.advanced(by: 100))
                .ratio(1)
        )
    }
    
    @available(iOS 15.0, tvOS 17.0, *)
    public convenience init(_ view: FBody, menu: UIMenu) {
        self.init(
            customView: FButton(label: view, menu: menu)
                .layoutPriority(.high.advanced(by: 100))
                .customized { $0.isUserInteractionEnabled = false }
                .ratio(1)
        )
        primaryAction = nil
        self.menu = menu
    }
    
    public convenience init(@FViewBuilder _ view: () -> FBody, action: (() -> Void)? = nil) {
        self.init(customView: FButton(label: view, action: action))
    }
    
    @available(iOS 15.0, tvOS 17.0, *)
    public convenience init(@FViewBuilder _ view: () -> FBody, menu: UIMenu) {
        self.init(view(), menu: menu)
    }
}
