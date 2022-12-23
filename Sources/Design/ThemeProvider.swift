//
//  ThemeProvider.swift
//  Core
//
//  Created by Duc Minh Nguyen on 11/5/21.
//

import UIKit
import DesignCore
#if canImport(LoggerCenter)
import LoggerCenter
#endif

public protocol ThemeProvider: AnyObject {
    static var shared: ThemeProvider { get }
    var theme: Theme { get }
    func register<Observer: Themable>(observer: Observer)
    func toggleTheme()
}

public class LegacyThemeProvider: NSObject, ThemeProvider {
    public static let shared: ThemeProvider = LegacyThemeProvider()
    public var theme: Theme {
        didSet {
            UserDefaults.standard.set(theme == .dark, forKey: "isDark")
            notifyObservers()
        }
    }
    private var observers: NSHashTable<AnyObject> = NSHashTable.weakObjects()

    private override init() {
        self.theme = UserDefaults.standard.bool(forKey: "isDark") ? .dark : .light
    }

    public func toggleTheme() {
        theme = theme == .light ? .dark : .light
    }

    public func register<Observer: Themable>(observer: Observer) {
        observer.apply(theme: theme)
        self.observers.add(observer)
    }

    private func notifyObservers() {
        DispatchQueue.main.async {
            self.observers.allObjects
                .compactMap({ $0 as? Themable })
                .forEach({ $0.apply(theme: self.theme) })
        }
    }
}

@available(iOS 13.0, *)
public class DefaultThemeProvider: NSObject, ThemeProvider {
    public static let shared: ThemeProvider = DefaultThemeProvider()
    public let theme: Theme = .adaptive

    private override init() {
        super.init()
    }

    public func register<Observer: Themable>(observer: Observer) {
        observer.apply(theme: theme)
    }

    public func toggleTheme() {
#if canImport(Logger)
        LogCenter.default.error("[Color][Fatal] The function \(DefaultThemeProvider.self).\(#function) shouldn't be used!")
        assertionFailure()
#else
        assertionFailure("[Color][Fatal] The function \(DefaultThemeProvider.self).\(#function) shouldn't be used!")
#endif
    }
}
