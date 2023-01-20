//
//  UIButton+.swift
//  Components
//
//  Created by Duc IT. Nguyen Minh on 31/05/2022.
//

import UIKit

@objc public class ClosureSleeve: NSObject {
    let closure:() -> Void
    public init(_ closure: @escaping() -> Void) { self.closure = closure }
    @objc public func invoke() { closure() }
}

public extension UIControl {
    /// Add action with out caring about selector and version compatible
    /// - Parameters:
    ///   - controlEvent: Control event for action to be triggered
    ///   - closure: Things happen
    func addAction(for controlEvent: UIControl.Event = .touchUpInside, _ closure: @escaping() -> Void) -> String {
        if #available(iOS 14.0, *) {
            let action = UIAction { (_: UIAction) in closure() }
            addAction(action, for: controlEvent)
            return action.identifier.rawValue
        } else {
            let sleeve = ClosureSleeve(closure)
            let identifier = "\(UUID())"
            addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvent)
            objc_setAssociatedObject(self, identifier, sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            return identifier
        }
    }
    
    func removeAction(for controlEvent: UIControl.Event = .touchUpInside, identifier: String? = nil) {
        guard let identifier = identifier else {
            // FIXME: Remove all actions for controlEvent if identifier is now provided
            return
        }
        if #available(iOS 14.0, *) {
            removeAction(identifiedBy: .init(rawValue: identifier), for: controlEvent)
        } else {
            guard let sleeve = objc_getAssociatedObject(self, identifier) as? ClosureSleeve else {
                // FIXME: Throw an error here if it is not found or we can just ignore like removeAction?
                return
            }
            removeTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvent)
        }
    }
}
