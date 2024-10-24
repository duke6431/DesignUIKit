//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 20/10/24.
//

import Foundation
import Combine
import DesignCore
import Logging

@propertyWrapper
public class FObservedPreference<T>: Loggable {
    fileprivate var observer: FPrefObservation<T>?
    
    let key: FPreferenceKey
    @Published private var value: T {
        didSet { UserDefaults.standard.set(value, forKey: key.rawValue) }
    }

    public var projectedValue: Published<T>.Publisher {
        get { $value }
        @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
        set { $value = newValue }
    }
    
    public var wrappedValue: T {
        get { value }
        set { value = newValue }
    }
    
    public init(_ key: FPreferenceKey, default value: T) {
        self.key = key
        if let value = UserDefaults.standard.object(forKey: key.rawValue) as? T {
            self.value = value
        } else {
            UserDefaults.standard.set(value, forKey: key.rawValue)
            self.value = value
        }
        defer { generateObserver() }
    }
    
    public init(_ key: FPreferenceKey, initialValue: T) {
        self.key = key
        self.value = initialValue
        defer { generateObserver() }
    }
    
    private func generateObserver() {
        self.observer = .init(key: key, onChange: { [weak self] _, new in
            guard let new else {
                self?.logger.error("Unable to obtain new value for type \(T.self).")
                return
            }
            self?.value = new
        }).customized({
#if DEBUG
            $0.with(\.logger, setTo: logger)
#endif
        })
    }
}

fileprivate final class FPrefObservation<T>: NSObject, Chainable {
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
    
#if DEBUG
    var logger: Logger?
#endif
    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: key.rawValue, context: nil)
#if DEBUG
        logger?.info("Deinitialized")
#endif
    }
}
