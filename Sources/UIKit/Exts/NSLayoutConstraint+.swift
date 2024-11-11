//
//  NSLayoutConstraint+.swift
//  Components
//
//  Created by Duc IT. Nguyen Minh on 25/05/2022.
//

import UIKit
import DesignCore

extension NSLayoutConstraint {
    public static func activate(@FBuilder<NSLayoutConstraint> _ constraints: () -> [NSLayoutConstraint]) {
        activate(constraints())
    }

    /**
     Change constraint multiplier

     - parameter multiplier: CGFloat
     - returns: NSLayoutConstraint
     */
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
