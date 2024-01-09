//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 08/01/2024.
//

import SwiftUI
import DesignCore

public class FontSystem: ObservableObject {
    public static var shared: FontSystem = .init()
    public static var defaultFont: FontFamily = .System()

    @Published public var current: FontFamily
    
    public init(current: FontFamily? = nil) {
        self.current = current ?? Self.defaultFont
    }
    
    public func use(_ font: FontFamily) {
        withAnimation {
            current = font
        }
    }
}

public class FontFamily {
    public var name: String
    
    public init(name: String) { self.name = name }
    
    public func font(with style: Style) -> UIFont {
        var font: UIFont?
        switch style.weight {
        case .ultraLight:
            font = .init(name: name + "-UltraLight", size: style.size)
        case .light:
            font = .init(name: name + "-Light", size: style.size)
        case .thin:
            font = .init(name: name + "-Thin", size: style.size)
        case .medium:
            font = .init(name: name + "-Medium", size: style.size)
        case .semibold:
            font = .init(name: name + "-Semibold", size: style.size)
        case .bold:
            font = .init(name: name + "-Bold", size: style.size)
        case .heavy:
            font = .init(name: name + "-Heavy", size: style.size)
        case .black:
            font = .init(name: name + "-Black", size: style.size)
        default:
            font = .init(name: name, size: style.size)
        }
        return font ?? FontFamily.System().font(with: style)
    }
}

public extension FontFamily {
    class System: FontFamily {
        init() { super.init(name: "system") }
        public override func font(with style: FontFamily.Style) -> UIFont {
            .systemFont(ofSize: style.size, weight: style.weight)
        }
    }
}

public extension FontFamily {
    struct Style {
        public var size: CGFloat
        public var weight: UIFont.Weight
    }
}

public extension FontFamily.Style {
    static var fontOrder: [FontFamily.Style] = [
        .caption2, .caption, .footnote, .callout,
        .subheadline, .body, .headline,
        .title3, .title2, .title, .largeTitle
    ]
    
    /// A font with the large title text style
    /// Large Title      Regular         34
    private(set) static var largeTitle = FontFamily.Style(size: 34, weight: .regular)
    
    /// A font with the title text style.
    /// Title 1          Regular         28
    private(set) static var title = FontFamily.Style(size: 28, weight: .regular)
    
    /// Create a font for second level hierarchical headings.
    /// Title 2          Regular         22
    private(set) static var title2 = FontFamily.Style(size: 22, weight: .regular)
    
    /// Create a font for third level hierarchical headings.
    /// Title 3          Regular         20
    private(set) static var title3 = FontFamily.Style(size: 20, weight: .regular)
    
    /// A font with the headline text style.
    /// Headline         Semibold        17
    private(set) static var headline = FontFamily.Style(size: 17, weight: .semibold)
    
    /// A font with the subheadline text style.
    /// Body             Regular         17
    private(set) static var body = FontFamily.Style(size: 17, weight: .regular)
    
    /// A font with the body text style.
    /// Callout          Regular         16
    private(set) static var subheadline = FontFamily.Style(size: 16, weight: .regular)
    
    /// A font with the callout text style.
    /// Subhead          Regular         15
    private(set) static var callout = FontFamily.Style(size: 15, weight: .regular)
    
    /// A font with the footnote text style.
    /// Footnote         Regular         13
    private(set) static var footnote = FontFamily.Style(size: 13, weight: .regular)
    
    /// A font with the caption text style.
    /// Caption 1        Regular         12
    private(set) static var caption = FontFamily.Style(size: 12, weight: .regular)
    
    /// Create a font with the alternate caption text style.
    /// Caption 2        Regular         11
    private(set) static var caption2 = FontFamily.Style(size: 11, weight: .regular)
}
