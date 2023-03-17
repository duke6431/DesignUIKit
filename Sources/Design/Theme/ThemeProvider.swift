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
    var theme: Theme { get }
    func register<Observer: Themable>(observer: Observer)
}

public class DefaultThemeProvider: NSObject, ThemeProvider {
    public var theme: Theme { didSet { notifyObservers() } }

    private var observers: NSHashTable<AnyObject> = NSHashTable.weakObjects()

    public init(with theme: Theme) {
        self.theme = theme
        super.init()
    }

    public func register<Observer: Themable>(observer: Observer) {
        observers.add(observer)
        observer.apply(theme: theme)
    }

    private func notifyObservers() {
        DispatchQueue.main.async {
            self.observers.allObjects
                .compactMap({ $0 as? Themable })
                .forEach({ $0.apply(theme: self.theme) })
        }
    }
}
