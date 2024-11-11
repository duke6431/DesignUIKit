//
//  File.swift
//
//
//  Created by Duc IT. Nguyen Minh on 22/01/2024.
//

import Foundation

public protocol UserDefaultKey {
    var rawValue: String { get }
}

@propertyWrapper
public struct UserDefault<Value: Codable> {
    let key: String
    var container: UserDefaults = .standard

    public init(key: UserDefaultKey) {
        self.key = key.rawValue
    }

    public init(key: String) {
        self.key = key
    }

    public var wrappedValue: Value? {
        get {
            guard let data = container.object(forKey: key) as? Data else { return nil }
            return try? JSONDecoder().decode(Value.self, from: data)
        }

        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                container.set(encoded, forKey: key)
            }
        }
    }
}
