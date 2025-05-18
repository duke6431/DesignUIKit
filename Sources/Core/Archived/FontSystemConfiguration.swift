//
//  File.swift
//  ComponentSystem
//
//  Created by Duke Nguyen on 26/9/24.
//

import Foundation

public extension FontSystem {
    /// Update Style of predefinded FontFamily.Style
    /// - Parameters:
    ///   - style: Font style that will receive an update
    ///   - newStyle: New Font style
    public func update(style: FontFamily.Style, with newStyle: FontFamily.Style) {
        switch style {
        case .largeTitle: FontFamily.Style.largeTitle = newStyle
        case .title: FontFamily.Style.title = newStyle
        case .title2: FontFamily.Style.title2 = newStyle
        case .title3: FontFamily.Style.title3 = newStyle
        case .headline: FontFamily.Style.headline = newStyle
        case .body: FontFamily.Style.body = newStyle
        case .subheadline: FontFamily.Style.subheadline = newStyle
        case .callout: FontFamily.Style.callout = newStyle
        case .footnote: FontFamily.Style.footnote = newStyle
        case .caption: FontFamily.Style.caption = newStyle
        case .caption2: FontFamily.Style.caption2 = newStyle
        default: break
        }
        objectWillChange.send()
    }

    /// Update Style of predefinded FontFamily.Style
    /// - Parameters:
    ///   - styles: All Font styles that will be updated
    ///     - style: Font style that will receive an update
    ///     - newStyle: New Font style
    public func update(_ styles: [(style: FontFamily.Style, newStyle: FontFamily.Style)]) {
        styles.forEach(update)
    }
}

public extension FontFamily.Style {
    static var fontOrder: [FontFamily.Style] = [
        .caption2, .caption, .footnote, .callout,
        .subheadline, .body, .headline,
        .title3, .title2, .title, .largeTitle
    ]

    /// A font with the large title text style
    /// Large Title - Regular - 34
    fileprivate(set) static var largeTitle = FontFamily.Style(size: 34, weight: .regular)

    /// A font with the title text style.
    /// Title 1 - Regular - 28
    fileprivate(set) static var title = FontFamily.Style(size: 28, weight: .regular)

    /// Create a font for second level hierarchical headings.
    /// Title 2 - Regular - 22
    fileprivate(set) static var title2 = FontFamily.Style(size: 22, weight: .regular)

    /// Create a font for third level hierarchical headings.
    /// Title 3 - Regular - 20
    fileprivate(set) static var title3 = FontFamily.Style(size: 20, weight: .regular)

    /// A font with the headline text style.
    /// Headline - Semibold - 17
    fileprivate(set) static var headline = FontFamily.Style(size: 17, weight: .semibold)

    /// A font with the subheadline text style.
    /// Body - Regular - 17
    fileprivate(set) static var body = FontFamily.Style(size: 17, weight: .regular)

    /// A font with the body text style.
    /// Callout - Regular - 16
    fileprivate(set) static var subheadline = FontFamily.Style(size: 16, weight: .regular)

    /// A font with the callout text style.
    /// Subhead - Regular - 15
    fileprivate(set) static var callout = FontFamily.Style(size: 15, weight: .regular)

    /// A font with the footnote text style.
    /// Footnote - Regular - 13
    fileprivate(set) static var footnote = FontFamily.Style(size: 13, weight: .regular)

    /// A font with the caption text style.
    /// Caption 1 - Regular - 12
    fileprivate(set) static var caption = FontFamily.Style(size: 12, weight: .regular)

    /// Create a font with the alternate caption text style.
    /// Caption 2 - Regular - 11
    fileprivate(set) static var caption2 = FontFamily.Style(size: 11, weight: .regular)
}
