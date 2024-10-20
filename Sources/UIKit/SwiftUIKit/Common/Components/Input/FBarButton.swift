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
        self.init(customView: FButton(label: view, action: action))
    }
    
    @available(iOS 14.0, *)
    public convenience init(_ view: FBodyComponent, menu: UIMenu) {
        view.isUserInteractionEnabled = false
        self.init(customView: view)
        primaryAction = nil
        self.menu = menu
    }
}
