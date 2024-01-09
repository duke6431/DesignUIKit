//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 08/01/2024.
//

import SwiftUI
import DesignCore

public class ThemeSystem: ObservableObject {
    private static var _defaultTheme: Theme?
    public static var defaultTheme: Theme {
        get {
            guard let _defaultTheme else { fatalError("Default theme not set") }
            return _defaultTheme
        }
        set {
            _defaultTheme = newValue
        }
    }
    
    @Published public var current: Theme

    public init(current: Theme? = nil) {
        self.current = current ?? Self.defaultTheme
    }
    
    public func use(_ theme: Theme) {
        withAnimation {
            self.current = theme
        }
    }
}

public protocol ThemeKey {
    var name: String { get }
}

public class Theme: ObservableObject, Identifiable, Codable {
    @Environment(\.colorScheme) var scheme
    private static var _defaultImage: String?
    public static var defaultImage: String {
        get {
            guard let _defaultImage else { fatalError("Default image not set") }
            return _defaultImage
        }
        set {
            _defaultImage = newValue
        }
    }
    private static var _defaultColor: String?
    public static var defaultColor: String {
        get {
            guard let _defaultColor else { fatalError("Default color not set") }
            return _defaultColor
        }
        set {
            _defaultColor = newValue
        }
    }
    
    public var id = UUID()
    public var name: String
    var styles: [Theme.Style: [String: String]]
    
    init(name: String, styles: [Theme.Style : [String : String]]) {
        self.name = name
        self.styles = styles
    }
    
    func color(key: ThemeKey) -> Color {
        .init(hex: styles[scheme.style]?[key.name] ?? Self.defaultColor)
    }
    
    func image(key: ThemeKey, bundle: Bundle = .main) -> Image {
        .init(styles[scheme.style]?[key.name] ?? Self.defaultImage, bundle: bundle)
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case styles
    }
}

public extension Theme {
    enum Style: String, Codable {
        case light
        case dark
    }
}

public extension ColorScheme {
    var style: Theme.Style {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        @unknown default:
            return .light
        }
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
