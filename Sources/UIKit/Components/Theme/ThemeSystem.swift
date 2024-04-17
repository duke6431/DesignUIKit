//
//  File.swift
//
//
//  Created by Duc IT. Nguyen Minh on 08/01/2024.
//

import DesignCore
import Foundation

public protocol Themable: AnyObject {
    func apply(theme: ThemeProvider)
}

public protocol ThemeProvider {
    func color(key: ThemeKey) -> BColor
}

public class ThemeSystem: ThemeProvider {
    public static var shared: ThemeSystem = .init()
    public static var defaultTheme: Theme = .empty
    
    public private(set) var current: Theme
    private var observers: NSHashTable<AnyObject> = NSHashTable.weakObjects()

    public init(current: Theme? = nil) {
        self.current = current ?? Self.defaultTheme
    }
    
    public func use(_ theme: Theme) {
        self.current = theme
        notifyObservers()
    }
    
    public func register<Observer: Themable>(observer: Observer) {
        observers.add(observer)
        observer.apply(theme: self)
    }
    func unregister<Observer: Theme>(_ observer: Observer) {
        observers.remove(observer)
    }
    private func notifyObservers() {
        DispatchQueue.main.async {
            self.observers.allObjects
                .compactMap({ $0 as? Themable })
                .forEach({ $0.apply(theme: self) })
        }
    }
    
    public func color(key: ThemeKey) -> BColor {
        current.color(key: key)
    }
    
    public func themes(in bundle: Bundle = .main, subdirectory: String?) throws -> [Theme] {
        try Theme.scan(bundle: bundle, subdirectory: subdirectory)
    }
    
    public func themes(in directory: URL) throws -> [Theme] {
        try Theme.scan(directory)
    }
}
