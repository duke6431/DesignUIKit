//
//  UIView+.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 25/9/24.
//
//  This file extends UIView to conform to the `Chainable` protocol,
//  enabling fluent-style property configuration and method chaining.
//

import UIKit
import DesignCore

/// Makes all `UIView` subclasses conform to the `Chainable` protocol.
///
/// This enables method chaining and fluent-style configuration for all UIKit views.
extension UIView: Chainable { }
