//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 3/25/24.
//

import Foundation

@propertyWrapper
public struct PreferenceItem<T> {
    let key: String
    let defaultValue: T
    let calculatedValue: ((T) -> (T))?

    public var wrappedValue: T {
        get {
            let res = UserDefaults.standard.value(forKey: key) as? T ?? defaultValue
            return calculatedValue?(res) ?? res
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }

    public init(_ key: String, _ defaultValue: T, _ calculatedValue: ((T) -> (T))? = nil) {
        self.key = key
        self.defaultValue = defaultValue
        self.calculatedValue = calculatedValue
    }
}

@propertyWrapper
public struct PreferenceData<T: Codable> {
    let key: String
    let defaultValue: T
    let calculatedValue: ((T) -> (T))?

    public var wrappedValue: T {
        get {
            guard let decoded = UserDefaults.standard.data(forKey: key)
            else { return defaultValue }

            let decoder = JSONDecoder()
            guard let res = try? decoder.decode(T.self, from: decoded)
            else { return defaultValue }
            
            return calculatedValue?(res) ?? res
        }
        set {
            let userDefaults = UserDefaults.standard
            let encoder = JSONEncoder()

            if let encodedData: Data = try? encoder.encode(newValue) {
                userDefaults.set(encodedData, forKey: key)
            } else {
                userDefaults.set(nil, forKey: key)
            }
        }
    }

    public init(_ key: String, _ defaultValue: T, calculatedValue: ((T) -> (T))? = nil) {
        self.key = key
        self.defaultValue = defaultValue
        self.calculatedValue = calculatedValue
    }
}
