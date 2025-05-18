//
//  FObservedPreference.swift
//  DesignRxUIKit
//
//  Created by Duke Nguyen on 2024/11/15.
//
//  A property wrapper for synchronizing a value with `UserDefaults` using `BehaviorRelay`.
//  Supports reactive observation and automatic propagation of value changes via KVO.
//

import Foundation
import DesignCore
import RxCocoa
import RxSwift

/// A property wrapper that synchronizes a value with `UserDefaults` using a `BehaviorRelay`.
/// Automatically observes changes to the associated key and updates the wrapped value reactively.
@propertyWrapper
public class FObservedPreference<T>: Loggable {
    fileprivate var observer: FPrefObservation<T>?
    
    let key: FPreferenceKey
    private var relay: BehaviorRelay<T> {
        didSet { UserDefaults.standard.set(relay.value, forKey: key.rawValue) }
    }
    
    /// Provides access to the underlying `BehaviorRelay` for binding or observation.
    public var projectedValue: BehaviorRelay<T> { relay }
    
    /// Gets or sets the current value stored in `UserDefaults`.
    public var wrappedValue: T {
        get { relay.value }
        set { relay.accept(newValue) }
    }
    
    /// Initializes the wrapper with a `UserDefaults` key and a default value.
    /// If no existing value is found in `UserDefaults`, the default is saved and used.
    ///
    /// - Parameters:
    ///   - key: The key used to store the value.
    ///   - value: The default value to use if none exists.
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
    
    /// Initializes the wrapper with a `UserDefaults` key and an initial value without saving to `UserDefaults`.
    ///
    /// - Parameters:
    ///   - key: The key associated with the preference.
    ///   - initialValue: The value to initialize the relay with.
    public init(_ key: FPreferenceKey, initialValue: T) {
        self.key = key
        self.relay = .init(value: initialValue)
        defer { generateObserver() }
    }
    
    /// Creates an observation object that monitors changes to the `UserDefaults` key
    /// and updates the `BehaviorRelay` when the value changes externally.
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

/// An internal observer object that listens for changes to a specific `UserDefaults` key
/// and invokes a closure with the old and new values.
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
    
    /// Handles KVO updates from `UserDefaults` and forwards changes to the observer's callback.
    override func observeValue(
        forKeyPath keyPath: String?, of object: Any?,
        change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?
    ) {
        guard let change = change, object != nil, keyPath == key.rawValue else { return }
        onChange(change[.oldKey] as? T, change[.newKey] as? T)
    }
    
    /// Cleans up the KVO observer on deallocation.
    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: key.rawValue, context: nil)
        logger.info("Deinitialized")
    }
}
