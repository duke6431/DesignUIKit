//
//  UIButton+.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2022/05/31.
//
//  Extensions and utilities for UIControl and UIButton to support closure-based actions
//  with compatibility across iOS versions. Includes error handling and action management
//  using associated objects.
//

import UIKit
import DesignCore

/// Error types related to UIControl actions.
public extension UIControl {
    /// Represents errors that can occur when handling UIControl actions.
    class Failure: Error {
        /// An optional message describing the error.
        var message: String?
        
        /// Error cases specific to adding or removing actions from a UIControl.
        class Action: Failure {
            /// Error indicating that a requested action was not found.
            static let notFound: Action = .init()
        }
        
        /// Sets a custom error message for this error.
        /// - Parameter message: The message to associate with the error.
        func with(message: String) {
            self.message = message
        }
    }
}

public extension UIControl {
    /// Associated object key for storing action event and identifier pairs.
    /// Used internally to keep track of added actions for each control.
    private static let actionIDs = ObjectAssociation<StructWrapper<[(UIControl.Event, String)]>>()
    
    /// An array of tuples representing the control events and their associated action identifiers.
    /// Used to track actions added to this control instance.
    var actionIDs: [(UIControl.Event, String)] {
        get { Self.actionIDs[self]?() ?? [] }
        set { Self.actionIDs[self] = .init(value: newValue) }
    }
    
    /// Adds a closure-based action for the specified control event.
    ///
    /// This method abstracts away differences between iOS versions:
    /// - On iOS 14 and later, it uses `UIAction`.
    /// - On earlier versions, it uses a target-action pattern with a closure "sleeve".
    ///
    /// - Parameters:
    ///   - controlEvent: The control event for which to add the action.
    ///   - closure: The closure to execute when the event is triggered.
    /// - Returns: A unique identifier for the added action.
    @discardableResult
    func addAction(for controlEvent: UIControl.Event, _ closure: @escaping() -> Void) -> String {
        var identifier: String
        if #available(iOS 14.0, *) {
            let action = UIAction { (_: UIAction) in closure() }
            addAction(action, for: controlEvent)
            identifier = action.identifier.rawValue
        } else {
            let sleeve = ClosureSleeve(closure)
            identifier = UUID().uuidString
            addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvent)
            objc_setAssociatedObject(self, identifier, sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        actionIDs.append((controlEvent, identifier))
        return identifier
    }
    
    /// Removes a previously added action for the specified control event and identifier.
    ///
    /// - Parameters:
    ///   - controlEvent: The control event for which to remove the action(s).
    ///   - identifier: The unique identifier of the action to remove. If `nil`, all actions for the event will be removed.
    /// - Throws: `UIControl.Failure.Action.notFound` if the specified action cannot be found (on iOS < 14).
    func removeAction(for controlEvent: UIControl.Event, identifier: String? = nil) throws {
        guard let identifier = identifier else {
            try actionIDs.forEach(removeAction(for:identifier:))
            return
        }
        if #available(iOS 14.0, *) {
            removeAction(identifiedBy: .init(rawValue: identifier), for: controlEvent)
        } else {
            guard let sleeve = objc_getAssociatedObject(self, identifier) as? ClosureSleeve else {
                throw Failure.Action.notFound
            }
            objc_setAssociatedObject(self, identifier, nil, .OBJC_ASSOCIATION_RETAIN)
            removeTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvent)
        }
    }
}

extension UIControl.Failure.Action: LocalizedError {
    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        message ?? String(describing: self)
    }
}
