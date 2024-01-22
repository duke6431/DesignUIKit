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
public struct UserDefault<Value> {
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
            return container.object(forKey: key) as? Value
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}
