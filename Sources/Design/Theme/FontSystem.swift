//
//  FontSystem.swift
//  DesignToolbox
//
//  Created by Duc IT. Nguyen Minh on 12/07/2022.
//

import UIKit

public protocol FontFamily {
    var ultraLight: UIFont { get }
    var thin: UIFont { get }
    var light: UIFont { get }
    var regular: UIFont { get }
    var medium: UIFont { get }
    var semibold: UIFont { get }
    var bold: UIFont { get }
    var heavy: UIFont { get }
    var black: UIFont { get }
    func font(with style: FontStyle) -> UIFont
}

public enum FontStyle {
    /// Semibold with size 28
    case title
    /// Semibold with size 24
    case title2
    /// Semibold with size 20
    case title3
    /// Semibold with size 17
    case headline
    /// Semibold with size 15
    case subheadline
    /// Regular with size 17
    case body
    /// Regular with size 15
    case body2
    /// Light with size 12
    case footnote
    /// Regular with size 13
    case caption
    /// Regular with size 12
    case caption2
}

extension FontStyle {
    public var size: CGFloat {
        switch self {
        case .title: return 28
        case .title2: return 24
        case .title3: return 20
        case .headline: return 17
        case .subheadline: return 15
        case .body: return 17
        case .body2: return 15
        case .footnote: return 12
        case .caption: return 13
        case .caption2: return 12
        }
    }

    public var weight: UIFont.Weight {
        switch self {
        case .title: return .semibold
        case .title2: return .semibold
        case .title3: return .semibold
        case .headline: return .semibold
        case .subheadline: return .semibold
        case .body: return .regular
        case .body2: return .regular
        case .footnote: return .light
        case .caption: return .regular
        case .caption2: return .regular
        }
    }
}

public class FontSystem {
    struct Default: FontFamily {
        private static let defaultSize: CGFloat = 17

        public var ultraLight: UIFont = .systemFont(ofSize: defaultSize, weight: .ultraLight)
        public var thin: UIFont = .systemFont(ofSize: defaultSize, weight: .thin)
        public var light: UIFont = .systemFont(ofSize: defaultSize, weight: .light)
        public var regular: UIFont = .systemFont(ofSize: defaultSize, weight: .regular)
        public var medium: UIFont = .systemFont(ofSize: defaultSize, weight: .medium)
        public var semibold: UIFont = .systemFont(ofSize: defaultSize, weight: .semibold)
        public var bold: UIFont = .systemFont(ofSize: defaultSize, weight: .bold)
        public var heavy: UIFont = .systemFont(ofSize: defaultSize, weight: .heavy)
        public var black: UIFont = .systemFont(ofSize: defaultSize, weight: .black)
        public func font(with style: FontStyle) -> UIFont {
            .systemFont(ofSize: style.size, weight: style.weight)
        }

        static let `default` = Default()
    }

    public static let shared: FontSystem = FontSystem()
    public private(set) var defaultFont: FontFamily

    init() {
        defaultFont = Default.default
    }

    public func register(family: FontFamily) {
        defaultFont = family
    }

    public static func font(with style: FontStyle) -> UIFont {
        shared.defaultFont.font(with: style)
    }
}
