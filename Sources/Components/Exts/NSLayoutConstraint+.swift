//
//  NSLayoutConstraint+.swift
//  Components
//
//  Created by Duc IT. Nguyen Minh on 25/05/2022.
//

import UIKit
import DesignCore

extension NSLayoutConstraint {
    public static func activate(@BuilderComponent<NSLayoutConstraint> _ constraints: () -> [NSLayoutConstraint]) {
        activate(constraints())
    }
}
