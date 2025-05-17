//
//  Theme.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2024/04/17.
//
//  Defines the `Theme` system for managing color palettes and visual styles,
//  including color lookup, dynamic color support, saving, and cloning.
//

import UIKit
import DesignCore
import FileKit

/// A protocol representing a key used for theme color lookups.
///
/// Conforming types provide a unique string name for referencing a color value in a theme palette.
public protocol ThemeKey {
    /// The unique name of the theme key.
    var name: String { get }
}

/// Represents a theme containing a set of color palettes and associated styles.
///
/// `Theme` objects can be encoded and decoded, cloned, saved to disk, and queried for color values by key and style.
/// Themes are uniquely identified by their `name`.
public class Theme: Identifiable, Codable, Loggable {
    /// An empty theme instance with no styles.
    static let empty: Theme = .init(name: "Empty", styles: [])
    
    /// The default color (hex string) used when a key is missing from a style.
    public static var defaultColor: String = "00000000"
    
    /// The unique identifier of the theme.
    public var id = UUID()
    /// The display name of the theme.
    public var name: String
    /// The set of color palettes associated with this theme.
    var styles: Set<Palette>
    
    /// Initializes a new theme with a name and a set of styles.
    /// - Parameters:
    ///   - name: The name of the theme.
    ///   - styles: The set of color palettes (styles) for the theme.
    public init(name: String, styles: Set<Palette>) {
        self.name = name
        self.styles = styles
    }
    
    /// Saves the theme as a JSON file in the user's documents directory.
    /// - Parameter filename: The filename to use (spaces replaced with dashes, `.json` appended).
    /// - Throws: An error if writing to disk fails.
    public func save(as filename: String) throws {
        try FileKit.write(self, to: Path.userDocuments + String(filename.replacingOccurrences(of: " ", with: "-") + ".json"))
    }
    
    /// Sets a color value for a given key and style in the theme.
    /// - Parameters:
    ///   - color: The UIColor to assign.
    ///   - key: The theme key to set.
    ///   - style: The palette style to update.
    /// - Throws: `ThemeError.missingPalette` if the style does not exist.
    public func set(color: UIColor, for key: ThemeKey, style: Theme.Style) throws {
        guard var newStyle = styles[style] else { throw ThemeError.missingPalette(style.rawValue) }
        newStyle[key.name] = color.hexString
        styles.remove(newStyle)
        styles.insert(newStyle)
    }
    
    /// Retrieves the color for a given key and style.
    /// - Parameters:
    ///   - key: The theme key to look up.
    ///   - style: The palette style to use.
    /// - Returns: The UIColor found, or the `defaultColor` if missing.
    public func color(key: ThemeKey, style: Theme.Style) -> UIColor {
        .init(hexString: styles[style]?[key.name] ?? Self.defaultColor)
    }
    
    /// Returns a dynamic color for a given key, adapting to the current user interface style.
    /// - Parameter key: The theme key to look up.
    /// - Returns: A dynamic UIColor that adapts to light/dark mode.
    public func color(key: ThemeKey) -> UIColor {
        .init(dynamicProvider: { [weak self] collection in
                .init(hexString: self?.styles[collection.userInterfaceStyle.style]?[key.name] ?? Self.defaultColor)
        })
    }
    
    /// Coding keys for encoding and decoding `Theme`.
    enum CodingKeys: String, CodingKey {
        /// The theme's name.
        case name
        /// The set of color palettes/styles.
        case styles
    }
}

public extension Theme {
    /// Creates a deep copy of the theme.
    /// - Returns: A new `Theme` instance with the same name and styles.
    func clone() -> Theme {
        .init(name: name, styles: styles)
    }
}

/// Hashable conformance for the `Theme` class.
///
/// Themes are considered equal if their `name` properties are equal.
extension Theme: Hashable {
    /// Returns whether two themes are equal by comparing their names.
    public static func == (lhs: Theme, rhs: Theme) -> Bool {
        lhs.name == rhs.name
    }
    
    /// Hashes the essential components of the theme (the name).
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
