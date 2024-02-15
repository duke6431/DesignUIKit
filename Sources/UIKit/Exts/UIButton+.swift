//
//  UIButton+.swift
//  Components
//
//  Created by Duc IT. Nguyen Minh on 31/05/2022.
//

import UIKit
import DesignCore

@objc public class ClosureSleeve: NSObject {
    let closure: () -> Void
    public init(_ closure: @escaping() -> Void) { self.closure = closure }
    @objc public func invoke() { closure() }
}
public extension UIControl {
    class Failure: Error {
        var message: String?
        class Action: Failure {
            static let notFound: Action = .init()
        }
        
        func with(message: String) {
            self.message = message
        }
    }
    
    private static let actionIDs = ObjectAssociation<StructWrapper<[(UIControl.Event, String)]>>()
    
    var actionIDs: [(UIControl.Event, String)] {
        get { Self.actionIDs[self]?() ?? [] }
        set { Self.actionIDs[self] = .init(value: newValue) }
    }
    
    /// Add action with out caring about selector and version compatible
    /// - Parameters:
    ///   - controlEvent: Control event for action to be triggered
    ///   - closure: Things happen
    @discardableResult
    func addAction(for controlEvent: UIControl.Event = .touchUpInside, _ closure: @escaping() -> Void) -> String {
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
    
    func removeAction(for controlEvent: UIControl.Event = .touchUpInside, identifier: String? = nil) throws {
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
    public var errorDescription: String? {
        message ?? String(describing: self)
    }
}

extension UIButton {
    private static let action = ObjectAssociation<ClosureSleeve>()
    private static let timerHolder = ObjectAssociation<Timer>()
    private static let holding = ObjectAssociation<StructWrapper<Bool>>()
    
    var action: ClosureSleeve? {
        get { Self.action[self] }
        set { Self.action[self] = newValue }
    }
    var timer: Timer? {
        get { Self.timerHolder[self] }
        set { Self.timerHolder[self] = newValue }
    }
    var holding: Bool {
        get { Self.holding[self]?.value ?? false }
        set { Self.holding[self] = StructWrapper(value: newValue) }
    }
    
    @objc func startHold() {
        holding = true
        guard let timer = timer else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            if self?.holding ?? false { RunLoop.main.add(timer, forMode: .default) }
        }
    }
    
    @objc func stopHold() {
        holding = false
        timer?.invalidate()
        timer = Timer(timeInterval: 0.1, repeats: true, block: { [weak self] _ in
            self?.action?.invoke()
        })
    }
    
    public func attachLongHold(_ action: @escaping (UIButton) -> Void, repeat: Bool = true) {
        stopHold()
        self.action = .init({ [weak self] in
            guard let self = self else { return }
            action(self)
        })
        self.addTarget(self, action: #selector(startHold), for: .touchDown)
        self.addTarget(self, action: #selector(stopHold), for: [.touchUpInside, .touchUpOutside])
    }
}
