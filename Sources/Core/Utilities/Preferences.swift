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

/// A type that represents a key for user preferences.
/// 
/// `FPreferenceKey` can be initialized using string literals or string interpolations, allowing for easy and flexible key creation.
public struct FPreferenceKey: ExpressibleByStringLiteral, ExpressibleByStringInterpolation {
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
public struct PreferenceItem<T> {
    /// The key used to store the preference in `UserDefaults`.
    let key: FPreferenceKey
    
    /// The default value returned if no value exists in `UserDefaults` for the key.
    let defaultValue: T
    
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
            guard let res = UserDefaults.standard.value(forKey: key.rawValue) as? T
            else {
                UserDefaults.standard.set(defaultValue, forKey: key.rawValue)
                return calculatedValue?(defaultValue) ?? defaultValue
            }
            return calculatedValue?(res) ?? res
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key.rawValue)
        }
    }
    
    /// Creates a new `PreferenceItem` with the specified key, default value, and optional transformation.
    /// - Parameters:
    ///   - key: The preference key.
    ///   - defaultValue: The default value to use if no value exists.
    ///   - calculatedValue: An optional closure to transform the stored or default value.
    public init(_ key: FPreferenceKey, _ defaultValue: T, _ calculatedValue: ((T) -> (T))? = nil) {
        self.key = key
        self.defaultValue = defaultValue
        self.calculatedValue = calculatedValue
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
            guard let decoded = UserDefaults.standard.data(forKey: key.rawValue),
                  let res = try? JSONDecoder().decode(T.self, from: decoded)
            else {
                if let encodedData = try? JSONEncoder().encode(defaultValue) {
                    UserDefaults.standard.set(encodedData, forKey: key.rawValue)
                }
                return calculatedValue?(defaultValue) ?? defaultValue
            }
            return calculatedValue?(res) ?? res
        }
        set {
            if let encodedData: Data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encodedData, forKey: key.rawValue)
            } else {
                UserDefaults.standard.set(nil, forKey: key.rawValue)
            }
        }
    }
    
    /// Creates a new `PreferenceData` with the specified key, default value, and optional transformation.
    /// - Parameters:
    ///   - key: The preference key.
    ///   - defaultValue: The default value to use if no data exists.
    ///   - calculatedValue: An optional closure to transform the decoded or default value.
    public init(_ key: FPreferenceKey, _ defaultValue: T, calculatedValue: ((T) -> (T))? = nil) {
        self.key = key
        self.defaultValue = defaultValue
        self.calculatedValue = calculatedValue
    }
}
