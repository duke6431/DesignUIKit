//
//  Preferences.swift
//  DesignCore
//
//  Created by Duke Nguyen on 2024/01/07.
//
//  Provides property wrappers for managing user preferences using `UserDefaults`,
//  with support for Codable types, default values, and runtime transformations.
//

import Foundation

/// A marker protocol for values that can be directly stored in `UserDefaults`.
public protocol PreferenceValue { }

extension String: PreferenceValue { }
extension Int: PreferenceValue { }
extension Double: PreferenceValue { }
extension Float: PreferenceValue { }
extension Bool: PreferenceValue { }
extension Data: PreferenceValue { }
extension Date: PreferenceValue { }
extension URL: PreferenceValue { }
extension Array: PreferenceValue where Element: PreferenceValue { }
extension Dictionary: PreferenceValue where Key == String, Value: PreferenceValue { }

/// A type that represents a key for user preferences.
/// 
/// `FPreferenceKey` can be initialized using string literals or string interpolations, allowing for easy and flexible key creation.
public struct FPreferenceKey: ExpressibleByStringLiteral, ExpressibleByStringInterpolation, Sendable {
    /// The raw string value of the preference key.
    public var rawValue: String
    
    /// Creates a new preference key from a string literal.
    /// - Parameter value: The string literal to use as the key.
    public init(stringLiteral value: StringLiteralType) { rawValue = value }
    
    /// Creates a new preference key from a string interpolation.
    /// - Parameter stringInterpolation: The string interpolation to use as the key.
    public init(stringInterpolation: DefaultStringInterpolation) { rawValue = stringInterpolation.description }
}

/// A property wrapper for storing and retrieving simple preference values from `UserDefaults`.
///
/// `PreferenceItem` supports a default value and an optional transformation closure to calculate the returned value.
/// It automatically persists changes to the wrapped value in `UserDefaults`.
///
/// - Note: The wrapped value type `T` should be compatible with `UserDefaults` storage.
@propertyWrapper
public struct PreferenceItem<T: PreferenceValue> {
    /// The key used to store the preference in `UserDefaults`.
    let key: FPreferenceKey
    
    /// The default value returned if no value exists in `UserDefaults` for the key.
    let defaultValue: T

    /// The preference store backing this property.
    let store: UserDefaults
    
    /// An optional closure to transform the stored or default value before returning it.
    let calculatedValue: ((T) -> (T))?
    
    /// The wrapped value representing the stored preference.
    ///
    /// On get, retrieves the value from `UserDefaults` if available, otherwise returns the default value.
    /// Applies the `calculatedValue` transformation if provided.
    ///
    /// On set, saves the new value to `UserDefaults`.
    public var wrappedValue: T {
        get {
            guard let res = store.object(forKey: key.rawValue) as? T
            else {
                store.set(defaultValue, forKey: key.rawValue)
                return calculatedValue?(defaultValue) ?? defaultValue
            }
            return calculatedValue?(res) ?? res
        }
        set {
            store.set(newValue, forKey: key.rawValue)
        }
    }
    
    /// Creates a new `PreferenceItem` with the specified key, default value, and optional transformation.
    /// - Parameters:
    ///   - key: The preference key.
    ///   - defaultValue: The default value to use if no value exists.
    ///   - calculatedValue: An optional closure to transform the stored or default value.
    ///   - store: The `UserDefaults` store to use. Defaults to `.standard`.
    public init(
        _ key: FPreferenceKey,
        _ defaultValue: T,
        _ calculatedValue: ((T) -> (T))? = nil,
        store: UserDefaults = .standard
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.calculatedValue = calculatedValue
        self.store = store
    }
}

/// A property wrapper for storing and retrieving `Codable` preference data from `UserDefaults`.
///
/// `PreferenceData` encodes and decodes the wrapped value using `JSONEncoder` and `JSONDecoder`.
/// Supports a default value and an optional transformation closure to calculate the returned value.
/// Automatically persists changes to the wrapped value in `UserDefaults`.
///
/// - Note: The wrapped value type `T` must conform to `Codable`.
@propertyWrapper
public struct PreferenceData<T: Codable> {
    /// The key used to store the preference data in `UserDefaults`.
    let key: FPreferenceKey
    
    /// The default value returned if no data exists in `UserDefaults` for the key.
    let defaultValue: T

    /// The preference store backing this property.
    let store: UserDefaults
    
    /// An optional closure to transform the decoded or default value before returning it.
    let calculatedValue: ((T) -> (T))?
    
    /// The wrapped value representing the stored preference data.
    ///
    /// On get, attempts to decode the value from `UserDefaults`. If decoding fails or no data exists,
    /// returns the default value. Applies the `calculatedValue` transformation if provided.
    ///
    /// On set, encodes the new value and saves it to `UserDefaults`. If encoding fails, removes the value.
    public var wrappedValue: T {
        get {
            guard let decoded = store.data(forKey: key.rawValue),
                  let res = try? JSONDecoder().decode(T.self, from: decoded)
            else {
                if let encodedData = try? JSONEncoder().encode(defaultValue) {
                    store.set(encodedData, forKey: key.rawValue)
                }
                return calculatedValue?(defaultValue) ?? defaultValue
            }
            return calculatedValue?(res) ?? res
        }
        set {
            if let encodedData: Data = try? JSONEncoder().encode(newValue) {
                store.set(encodedData, forKey: key.rawValue)
            } else {
                store.removeObject(forKey: key.rawValue)
            }
        }
    }
    
    /// Creates a new `PreferenceData` with the specified key, default value, and optional transformation.
    /// - Parameters:
    ///   - key: The preference key.
    ///   - defaultValue: The default value to use if no data exists.
    ///   - calculatedValue: An optional closure to transform the decoded or default value.
    ///   - store: The `UserDefaults` store to use. Defaults to `.standard`.
    public init(
        _ key: FPreferenceKey,
        _ defaultValue: T,
        calculatedValue: ((T) -> (T))? = nil,
        store: UserDefaults = .standard
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.calculatedValue = calculatedValue
        self.store = store
    }
}
