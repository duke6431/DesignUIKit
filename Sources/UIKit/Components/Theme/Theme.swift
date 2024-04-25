//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 4/17/24.
//

import Foundation
import DesignCore
import FileKit

public protocol ThemeKey {
    var name: String { get }
}

public class Theme: ObservableObject, Identifiable, Codable {
    static let empty: Theme = .init(name: "Empty", styles: [])
    
    private static var _defaultImage: String = "photo"
    private static var _defaultImageChanged: Bool = false
    public static var defaultImage: String {
        get {
            return _defaultImage
        }
        set {
            _defaultImageChanged = true
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
    
    public func save(as filename: String) throws {
        try FileKit.write(self, to: Path.userDocuments + String(filename.replacingOccurrences(of: " ", with: "-") + ".json"))
    }
    
    public func set(color: BColor, for key: ThemeKey, style: Theme.Style) throws {
        guard var newStyle = styles[style] else { throw ThemeError.missingPalette(style.rawValue) }
        newStyle[key.name] = color.hexString
        styles.remove(newStyle)
        styles.insert(newStyle)
    }
    
    public func color(key: ThemeKey, style: Theme.Style) -> BColor {
        .init(hexString: styles[style]?[key.name] ?? Self.defaultColor)
    }
    
    public func color(key: ThemeKey) -> BColor {
        .init(dynamicProvider: { [weak self] collection in
            .init(hexString: self?.styles[collection.userInterfaceStyle.style]?[key.name] ?? Self.defaultColor)
        })
    }
    
    public func image(key: ThemeKey, bundle: Bundle = .main) -> BImage {
        guard let light = BImage(named: styles[.light]?[key.name] ?? "", in: bundle, with: nil),
              let dark = BImage(named: styles[.dark]?[key.name] ?? "", in: bundle, with: nil) else {
            if Self._defaultImageChanged {
                return BImage(named: Self.defaultImage, in: bundle, with: nil) ?? BImage()
            } else {
                return BImage(systemName: Self.defaultImage) ?? BImage()
            }
        }
        return BImage(dynamicImageWithLight: light, dark: dark) ?? BImage()
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
