//
//  NSLayoutConstraint+.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2022/05/25.
//
//  Extension utilities for `NSLayoutConstraint`, including builder-style activation
//  and support for creating a modified constraint with a new multiplier.
//

import UIKit
import DesignCore

extension NSLayoutConstraint {
    /// Activates a list of constraints constructed using the result builder syntax.
    ///
    /// - Parameter constraints: A closure returning an array of `NSLayoutConstraint` to activate.
    public static func activate(@FBuilder<NSLayoutConstraint> _ constraints: () -> [NSLayoutConstraint]) {
        activate(constraints())
    }
    
    /// Returns a new constraint that is a copy of the receiver, but with the given multiplier.
    ///
    /// - Parameter multiplier: The new multiplier value.
    /// - Returns: A new `NSLayoutConstraint` with the specified multiplier.
    func with(multiplier: CGFloat) -> NSLayoutConstraint {
        guard let firstItem = firstItem else { return self }
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant
        )
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = shouldBeArchived
        newConstraint.identifier = identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
