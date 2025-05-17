//
//  ThemeSystem.swift
//
//
//  A centralized system for managing app themes, allowing dynamic theme switching,
//  observer registration for theme changes, and providing theme colors.
//  Supports UIKit trait collection changes and custom theme implementations.
//
//  Created by Duc IT. Nguyen Minh on 08/01/2024.
//

import DesignCore
import Foundation
import FileKit
import UIKit

/// A protocol that defines an interface for objects that can apply a theme.
///
/// Conforming types should implement the `apply(theme:)` method to update their appearance
/// based on the provided theme.
public protocol Themable: AnyObject {
    /// Applies the given theme to the conforming object.
    /// - Parameter theme: The theme provider supplying theme information.
    func apply(theme: ThemeProvider)
}

/// A protocol that extends `Themable` to support Core Graphics (CG) related theme updates.
///
/// Conforming types should implement `applyCG(theme:)` to update any CG-related properties
/// when the theme changes or when traits change (e.g., dark mode).
public protocol CGThemable: Themable {
    /// Applies Core Graphics related theme updates.
    /// - Parameter theme: The theme provider supplying theme information.
    func applyCG(theme: ThemeProvider)
}

/// A protocol that provides theme-related data, such as colors.
///
/// Types conforming to this protocol supply theme assets based on keys.
public protocol ThemeProvider {
    /// Returns a color associated with the given theme key.
    /// - Parameter key: The key identifying the color in the theme.
    /// - Returns: A `UIColor` corresponding to the key.
    func color(key: ThemeKey) -> UIColor
}

/// A singleton class responsible for managing the app's current theme,
/// notifying registered observers about theme changes, and providing theme assets.
///
/// Observers conforming to `Themable` or `CGThemable` can register to receive theme updates.
/// Supports dynamic theme switching and handles UIKit trait collection changes.
public class ThemeSystem: ThemeProvider {
    
    /// The shared singleton instance of `ThemeSystem`.
    public static var shared: ThemeSystem = .init()
    
    /// The default theme used when no current theme is set.
    public static var defaultTheme: Theme = .empty
    
    /// The currently active theme.
    public private(set) var current: Theme
    
    /// A weak hash table of observers interested in theme updates.
    private var observers: NSHashTable<AnyObject> = NSHashTable.weakObjects()
    
    /// Initializes a new instance of `ThemeSystem` with an optional starting theme.
    /// - Parameter current: The initial theme to use. Defaults to `defaultTheme` if nil.
    public init(current: Theme? = nil) {
        self.current = current ?? Self.defaultTheme
    }
    
    /// Switches the current theme to the provided one and notifies all observers.
    /// - Parameter theme: The new theme to apply.
    public func use(_ theme: Theme) {
        self.current = theme
        notifyObservers()
    }
    
    /// Handles UIKit trait collection changes by notifying all `CGThemable` observers
    /// to update their Core Graphics related theme properties.
    public func onTraitCollectionChange() {
        DispatchQueue.main.async {
            self.observers.allObjects
                .compactMap({ $0 as? CGThemable })
                .forEach(self.notify)
        }
    }
    
    /// Registers an observer to receive theme updates.
    ///
    /// If the observer is not already registered, it will be added and immediately notified
    /// with the current theme.
    ///
    /// - Parameter observer: The object conforming to `Themable` to register.
    public func register<Observer: Themable>(observer: Observer) {
        if !observers.contains(observer) {
            observers.add(observer)
        }
        notify(observer)
    }
    
    /// Unregisters an observer from receiving theme updates.
    /// - Parameter observer: The observer to remove.
    func unregister<Observer: Theme>(_ observer: Observer) {
        observers.remove(observer)
    }
    
    /// Notifies all registered observers of a theme change asynchronously on the main thread.
    private func notifyObservers() {
        DispatchQueue.main.async {
            self.observers.allObjects
                .compactMap({ $0 as? Themable })
                .forEach(self.notify)
        }
    }
    
    /// Notifies a single observer to apply the current theme.
    /// If the observer conforms to `CGThemable`, also triggers CG-related updates.
    /// - Parameter observer: The observer to notify.
    func notify(_ observer: Themable) {
        observer.apply(theme: self)
        if let observer = observer as? CGThemable {
            notifyCG(observer)
        }
    }
    
    /// Notifies a `CGThemable` observer to apply Core Graphics related theme updates.
    /// - Parameter observer: The `CGThemable` observer to notify.
    func notifyCG(_ observer: CGThemable) {
        observer.applyCG(theme: self)
    }
    
    /// Returns a color from the current theme for the specified key.
    /// - Parameter key: The theme key identifying the desired color.
    /// - Returns: A `UIColor` for the specified key.
    public func color(key: ThemeKey) -> UIColor {
        current.color(key: key)
    }
    
    /// Scans and returns all themes available in the specified bundle and subdirectory.
    /// - Parameters:
    ///   - bundle: The bundle to scan. Defaults to the main bundle.
    ///   - subdirectory: An optional subdirectory within the bundle to scan.
    /// - Throws: An error if theme scanning fails.
    /// - Returns: An array of available `Theme` objects.
    public func themes(in bundle: Bundle = .main, subdirectory: String?) throws -> [Theme] {
        try Theme.scan(bundle: bundle, subdirectory: subdirectory)
    }
    
    /// Scans and returns all themes available in the specified directory path.
    /// - Parameter directory: The directory path to scan.
    /// - Throws: An error if theme scanning fails.
    /// - Returns: An array of available `Theme` objects.
    public func themes(in directory: Path) throws -> [Theme] {
        try Theme.scan(directory)
    }
}
