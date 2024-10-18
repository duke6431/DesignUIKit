//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 4/17/24.
//

import UIKit
import DesignCore
import FileKit

public protocol ThemeKey {
    var name: String { get }
}

public class Theme: Identifiable, Codable, Loggable {
    static let empty: Theme = .init(name: "Empty", styles: [])
    
    public static var defaultColor: String = "00000000"
    
    public var id = UUID()
    public var name: String
    var styles: Set<Palette>
    
    public init(name: String, styles: Set<Palette>) {
        self.name = name
        self.styles = styles
    }
    
    public func save(as filename: String) throws {
        try FileKit.write(self, to: Path.userDocuments + String(filename.replacingOccurrences(of: " ", with: "-") + ".json"))
    }
    
    public func set(color: UIColor, for key: ThemeKey, style: Theme.Style) throws {
        guard var newStyle = styles[style] else { throw ThemeError.missingPalette(style.rawValue) }
        newStyle[key.name] = color.hexString
        styles.remove(newStyle)
        styles.insert(newStyle)
    }
    
    public func color(key: ThemeKey, style: Theme.Style) -> UIColor {
        .init(hexString: styles[style]?[key.name] ?? Self.defaultColor)
    }
    
    public func color(key: ThemeKey) -> UIColor {
        .init(dynamicProvider: { [weak self] collection in
            .init(hexString: self?.styles[collection.userInterfaceStyle.style]?[key.name] ?? Self.defaultColor)
        })
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case styles
    }
}

public extension Theme {
    func clone() -> Theme {
        .init(name: name, styles: styles)
    }
}

extension Theme: Hashable {
    public static func == (lhs: Theme, rhs: Theme) -> Bool {
        lhs.name == rhs.name
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
