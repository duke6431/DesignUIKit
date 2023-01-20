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

    /**
     Change multiplier constraint

     - parameter multiplier: CGFloat
     - returns: NSLayoutConstraint
    */
    func setMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
        guard let firstItem = firstItem else { return self }
        NSLayoutConstraint.deactivate([self])

        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)

        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier

        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
