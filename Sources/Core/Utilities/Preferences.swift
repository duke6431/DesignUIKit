//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 3/25/24.
//

import Foundation

public struct FPreferenceKey: ExpressibleByStringLiteral, ExpressibleByStringInterpolation {
    public var rawValue: String
    
    public init(stringLiteral value: StringLiteralType) { rawValue = value }
    public init(stringInterpolation: DefaultStringInterpolation) { rawValue = stringInterpolation.description }
}

@propertyWrapper
public struct PreferenceItem<T> {
    let key: FPreferenceKey
    let defaultValue: T
    let calculatedValue: ((T) -> (T))?

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

    public init(_ key: FPreferenceKey, _ defaultValue: T, _ calculatedValue: ((T) -> (T))? = nil) {
        self.key = key
        self.defaultValue = defaultValue
        self.calculatedValue = calculatedValue
    }
}

@propertyWrapper
public struct PreferenceData<T: Codable> {
    let key: FPreferenceKey
    let defaultValue: T
    let calculatedValue: ((T) -> (T))?

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

    public init(_ key: FPreferenceKey, _ defaultValue: T, calculatedValue: ((T) -> (T))? = nil) {
        self.key = key
        self.defaultValue = defaultValue
        self.calculatedValue = calculatedValue
    }
}
