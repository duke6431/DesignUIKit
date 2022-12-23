//
//  UIButton+.swift
//  Components
//
//  Created by Duc IT. Nguyen Minh on 31/05/2022.
//

import UIKit

public extension UIControl {
    /// Add action with out caring about selector and version compatible
    /// - Parameters:
    ///   - controlEvent: Control event for action to be triggered
    ///   - closure: Things happen
    func addAction(for controlEvent: UIControl.Event = .touchUpInside, _ closure: @escaping() -> Void) {
        if #available(iOS 14.0, *) {
            addAction(UIAction { (_: UIAction) in closure() }, for: controlEvent)
        } else {
            @objc class ClosureSleeve: NSObject {
                let closure:() -> Void
                init(_ closure: @escaping() -> Void) { self.closure = closure }
                @objc func invoke() { closure() }
            }
            let sleeve = ClosureSleeve(closure)
            addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvent)
            objc_setAssociatedObject(self, "\(UUID())", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}
