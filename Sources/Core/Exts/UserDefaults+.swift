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
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard
    
    init(key: UserDefaultKey, default: Value) {
        self.key = key.rawValue
        self.defaultValue = `default`
    }
    
    init(key: String, default: Value) {
        self.key = key
        self.defaultValue = `default`
    }
    
    var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}
