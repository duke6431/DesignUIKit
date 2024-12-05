//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 15/11/24.
//

import Foundation
import DesignCore
import RxCocoa
import RxSwift

@propertyWrapper
public class FObservedPreference<T>: Loggable {
    fileprivate var observer: FPrefObservation<T>?
    
    let key: FPreferenceKey
    private var relay: BehaviorRelay<T> {
        didSet { UserDefaults.standard.set(relay.value, forKey: key.rawValue) }
    }
    
    public var projectedValue: BehaviorRelay<T> { relay }
    
    public var wrappedValue: T {
        get { relay.value }
        set { relay.accept(newValue) }
    }
    
    public init(_ key: FPreferenceKey, default value: T) {
        self.key = key
        if let value = UserDefaults.standard.object(forKey: key.rawValue) as? T {
            self.relay = .init(value: value)
        } else {
            UserDefaults.standard.set(value, forKey: key.rawValue)
            self.relay = .init(value: value)
        }
        defer { generateObserver() }
    }
    
    public init(_ key: FPreferenceKey, initialValue: T) {
        self.key = key
        self.relay = .init(value: initialValue)
        defer { generateObserver() }
    }
    
    private func generateObserver() {
        self.observer = .init(key: key, onChange: { [weak self] _, new in
            guard let new else {
                self?.logger.error("Unable to obtain new value for type \(T.self).")
                return
            }
            self?.relay.accept(new)
        })
    }
}

private final class FPrefObservation<T>: NSObject, Chainable, Loggable {
    let key: FPreferenceKey
    private var onChange: (T?, T?) -> Void
    
    init(key: FPreferenceKey, onChange: @escaping (T?, T?) -> Void) {
        self.onChange = onChange
        self.key = key
        super.init()
        UserDefaults.standard.addObserver(
            self, forKeyPath: key.rawValue,
            options: [.old, .new], context: nil
        )
    }
    
    override func observeValue(
        forKeyPath keyPath: String?, of object: Any?,
        change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?
    ) {
        guard let change = change, object != nil, keyPath == key.rawValue else { return }
        onChange(change[.oldKey] as? T, change[.newKey] as? T)
    }
    
    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: key.rawValue, context: nil)
#if DEBUG
        logger.info("Deinitialized")
#endif
    }
}
