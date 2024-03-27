//
//  UIButton+.swift
//  Components
//
//  Created by Duc IT. Nguyen Minh on 31/05/2022.
//

#if canImport(UIKit)
import UIKit

public typealias BControl = UIControl
public typealias BControlEvent = UIControl.Event
#else
import AppKit

public typealias BControl = NSControl
public typealias BControlEvent = NSEvent.EventTypeMask
#endif
import DesignCore

@objc public class ClosureSleeve: NSObject {
    let closure: () -> Void
    public init(_ closure: @escaping() -> Void) { self.closure = closure }
    @objc public func invoke() { closure() }
}

#if canImport(UIKit)
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

class HoldConfiguration {
    var onHold: ClosureSleeve?
    var onRelease: ClosureSleeve?
    var delay: TimeInterval = 0.15
    var timer: Timer?
    var holding: Bool = false
    var shouldRepeat: Bool = false
}

extension BButton {
    private static let holdConfiguration = ObjectAssociation<HoldConfiguration>()

    var holdConfiguration: HoldConfiguration {
        get { Self.holdConfiguration[self] ?? .init() }
        set { Self.holdConfiguration[self] = newValue }
    }
    
    @objc func startHold() {
        holdConfiguration.holding = true
        guard let timer = holdConfiguration.timer else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + holdConfiguration.delay) { [weak self] in
            if self?.holdConfiguration.holding ?? false {
                RunLoop.main.add(timer, forMode: .default)
                self?.holdConfiguration.onHold?.invoke()
            }
        }
    }
    
    @objc func stopHold() {
        holdConfiguration.onRelease?.invoke()
        holdConfiguration.holding = false
        holdConfiguration.timer?.invalidate()
        holdConfiguration.timer = Timer(timeInterval: 0.1, repeats: holdConfiguration.shouldRepeat, block: { [weak self] _ in
            self?.holdConfiguration.onHold?.invoke()
        })
    }
    
    public func attachLongHold(
        delay: TimeInterval = 0.15,
        shouldRepeat: Bool = false,
        onHold: @escaping (BButton) -> Void,
        onRelease: ((BButton) -> Void)? = nil
    ) {
        holdConfiguration = .init()
        holdConfiguration.shouldRepeat = shouldRepeat
        holdConfiguration.timer?.invalidate()
        holdConfiguration.timer = Timer(timeInterval: 0.1, repeats: shouldRepeat, block: { [weak self] _ in
            self?.holdConfiguration.onHold?.invoke()
        })
        self.holdConfiguration.onHold = .init { [weak self] in
            guard let self = self else { return }
            onHold(self)
        }
        self.holdConfiguration.onRelease = .init { [weak self] in
            guard let self = self else { return }
            onRelease?(self)
        }
        self.addTarget(self, action: #selector(startHold), for: .touchDown)
        self.addTarget(self, action: #selector(stopHold), for: [.touchUpInside, .touchUpOutside])
    }
}
#endif
