//
//  File.swift
//
//
//  Created by Duc IT. Nguyen Minh on 08/01/2024.
//

import DesignCore
import Foundation
import FileKit
import UIKit

public protocol Themable: AnyObject {
    func apply(theme: ThemeProvider)
}

public protocol CGThemable: Themable {
    func applyCG(theme: ThemeProvider)
}

public protocol ThemeProvider {
    func color(key: ThemeKey) -> UIColor
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

    public func onTraitCollectionChange() {
        DispatchQueue.main.async {
            self.observers.allObjects
                .compactMap({ $0 as? CGThemable })
                .forEach(self.notify)
        }
    }

    public func register<Observer: Themable>(observer: Observer) {
        if !observers.contains(observer) {
            observers.add(observer)
        }
        notify(observer)
    }

    func unregister<Observer: Theme>(_ observer: Observer) {
        observers.remove(observer)
    }

    private func notifyObservers() {
        DispatchQueue.main.async {
            self.observers.allObjects
                .compactMap({ $0 as? Themable })
                .forEach(self.notify)
        }
    }

    func notify(_ observer: Themable) {
        observer.apply(theme: self)
        if let observer = observer as? CGThemable {
            notifyCG(observer)
        }
    }

    func notifyCG(_ observer: CGThemable) {
        observer.applyCG(theme: self)
    }

    public func color(key: ThemeKey) -> UIColor {
        current.color(key: key)
    }

    public func themes(in bundle: Bundle = .main, subdirectory: String?) throws -> [Theme] {
        try Theme.scan(bundle: bundle, subdirectory: subdirectory)
    }

    public func themes(in directory: Path) throws -> [Theme] {
        try Theme.scan(directory)
    }
}
