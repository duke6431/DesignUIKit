//
//  UIButton+.swift
//  Components
//
//  Created by Duc IT. Nguyen Minh on 31/05/2022.
//

import UIKit
import DesignCore

public typealias BControl = UIControl
public typealias BControlEvent = UIControl.Event

public extension BControl {
    class Failure: Error {
        var message: String?
        class Action: Failure {
            static let notFound: Action = .init()
        }
        
        func with(message: String) {
            self.message = message
        }
    }
}

public extension BControl {
    private static let actionIDs = ObjectAssociation<StructWrapper<[(BControlEvent, String)]>>()
    
    var actionIDs: [(BControlEvent, String)] {
        get { Self.actionIDs[self]?() ?? [] }
        set { Self.actionIDs[self] = .init(value: newValue) }
    }
    
    /// Add action with out caring about selector and version compatible
    /// - Parameters:
    ///   - controlEvent: Control event for action to be triggered
    ///   - closure: Things happen
    @discardableResult
    func addAction(for controlEvent: BControlEvent, _ closure: @escaping() -> Void) -> String {
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
    
    func removeAction(for controlEvent: BControlEvent, identifier: String? = nil) throws {
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

extension BControl.Failure.Action: LocalizedError {
    public var errorDescription: String? {
        message ?? String(describing: self)
    }
}
