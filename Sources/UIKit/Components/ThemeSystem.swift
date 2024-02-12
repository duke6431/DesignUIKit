//
//  File.swift
//
//
//  Created by Duc IT. Nguyen Minh on 08/01/2024.
//

import UIKit
import DesignCore

public protocol Themable: AnyObject {
    func apply(theme: ThemeProvider)
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
    
    public func color(key: ThemeKey) -> UIColor {
        current.color(key: key)
    }
}

public protocol ThemeKey {
    var name: String { get }
}

public class Theme: ObservableObject, Identifiable, Codable {
    fileprivate static let empty: Theme = .init(name: "Empty", styles: [])
    
    private static var _defaultImage: String = "photo"
    private static var _defaultImageChanged: Bool = false
    public static var defaultImage: String {
        get {
            return _defaultImage
        }
        set {
            _defaultImage = newValue
        }
    }
    public static var defaultColor: String = "00000000"
    
    public var id = UUID()
    public var name: String
    var styles: Set<Palette>
    
    public init(name: String, styles: Set<Palette>) {
        self.name = name
        self.styles = styles
    }
    
    public func color(key: ThemeKey) -> UIColor {
        return .init(dynamicProvider: { [weak self] collection in
            return .init(hexString: self?.styles[collection.userInterfaceStyle.style]?[key.name] ?? Self.defaultColor)
        })
    }
    
    public func image(key: ThemeKey, bundle: Bundle = .main) -> UIImage {
        guard let light = UIImage(named: styles[.light]?[key.name] ?? "", in: bundle, with: nil),
              let dark = UIImage(named: styles[.dark]?[key.name] ?? "", in: bundle, with: nil) else {
            if Self._defaultImageChanged {
                return UIImage(named: Self.defaultImage, in: bundle, with: nil) ?? UIImage()
            } else {
                return UIImage(systemName: Self.defaultImage) ?? UIImage()
            }
        }
        return UIImage(dynamicImageWithLight: light, dark: dark) ?? UIImage()
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case styles
    }
}

public extension Theme {
    /// Theme might only has 2 styles: dark and light
    @frozen
    enum Style: String, Codable {
        case light
        case dark
    }
    
    struct Palette: Codable, Hashable {
        var style: Style
        var colors: [String: String]
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(style)
        }
        
        subscript(_ key: String) -> String? {
            colors[key]
        }
    }
}

extension Set where Element == Theme.Palette {
    subscript(_ style: Theme.Style) -> Element? {
        first { $0.style == style }
    }
}

extension UIUserInterfaceStyle {
    var style: Theme.Style {
        switch self {
        case .light, .unspecified:
            return .light
        case .dark:
            return .dark
        @unknown default:
            return .light
        }
    }
}

extension UIImage {
    /// Creates a dynamic image that supports displaying a different image asset when dark mode is active.
    convenience init?(dynamicImageWithLight makeLight: @autoclosure () -> UIImage?,
                      dark makeDark: @autoclosure () -> UIImage?
    ) {
        self.init()
        guard let lightImg = makeLight(), let darkImg = makeDark() else { return nil }
        self.imageAsset?.register(lightImg, with: UITraitCollection(userInterfaceStyle: .light))
        self.imageAsset?.register(darkImg, with: UITraitCollection(userInterfaceStyle: .dark))
    }
}

public extension Theme {
    static func load(from bundle: Bundle, name: String) throws -> Theme {
        guard let path = bundle.url(forResource: name, withExtension: "json") else {
            throw ThemeError.notFound(name)
        }
        do {
            return try JSONDecoder().decode(Theme.self, from: try Data(contentsOf: path))
        } catch {
            throw ThemeError.decodeFailed(name, error: error)
        }
    }
}

public enum ThemeError: Error {
    case notFound(_ name: String)
    case decodeFailed(_ name: String, error: Error)
}

extension ThemeError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notFound(let name):
            return "Theme \(name) not found"
        case .decodeFailed(let name, let error):
            return "Decoding theme \(name) failed with error:\n\(error.localizedDescription)"
        }
    }
}
