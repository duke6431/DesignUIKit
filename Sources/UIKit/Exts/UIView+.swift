//
//  UIView+.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2024/09/25.
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
