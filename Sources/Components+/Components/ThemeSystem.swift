//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 08/01/2024.
//

import SwiftUI
import DesignCore

public class ThemeSystem: ObservableObject {
    public static var shared: ThemeSystem = .init()
    
    public static var defaultTheme: Theme = .empty
    
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
    fileprivate static let empty: Theme = .init(name: "Empty", styles: [:])
    
    @Environment(\.colorScheme) var scheme
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
    var styles: [Theme.Style: [String: String]]
    
    public init(name: String, styles: [Theme.Style : [String : String]]) {
        self.name = name
        self.styles = styles
    }
    
    public func color(key: ThemeKey) -> Color {
        .init(hex: styles[scheme.style]?[key.name] ?? Self.defaultColor)
    }
    
    public func image(key: ThemeKey, bundle: Bundle = .main) -> Image {
        guard let img = styles[scheme.style]?[key.name] else {
            if Self._defaultImageChanged {
                return .init(Self.defaultImage, bundle: bundle)
            } else {
                return Image(systemName: Self.defaultImage)
            }
        }
        return .init(img, bundle: bundle)
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
