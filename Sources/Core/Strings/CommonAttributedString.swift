//
//  CommonAttributedString.swift
//  Core
//
//  Created by Duc IT. Nguyen Minh on 13/06/2022.
//

import UIKit

public protocol AttributedStringBuildable {
    var built: NSMutableAttributedString { get }
}

public extension NSAttributedString {
    static func build(@FBuilder<AttributedStringBuildable> _ strings: () -> [AttributedStringBuildable]) -> NSAttributedString {
        strings().reduce(NSMutableAttributedString()) { $0.appended(with: $1.built) }
    }
}

extension CommonAttributedString: AttributedStringBuildable {
    /// Build metadata into NSAttributedString
    /// - Returns: Swift attributed string
    public var built: NSMutableAttributedString {
        NSMutableAttributedString(string: string, attributes: attributes)
    }
}

extension Array: AttributedStringBuildable where Element == CommonAttributedString {
    public var built: NSMutableAttributedString {
        reduce(.init()) {
            $0.appended(with: $1.built)
        }
    }
}

public class CommonAttributedString: Chainable {
    public var attributes: [NSAttributedString.Key: Any] = [:]
    public var string: String

    public init(_ string: String = "") {
        self.string = string
    }
    
    /// Existed key-value will be replaced
    public func merged(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        self.attributes.merge(attributes) { _, second in second }
        return self
    }
    
    /// Apply foreground color (text color) to string
    public func foreground(_ color: UIColor) -> Self {
        merged([.foregroundColor: color])
    }
    
    /// Apply background color to occupied space of the string
    public func background(_ color: UIColor) -> Self {
        merged([.backgroundColor: color])
    }
    
    /// Apply specific font to the string
    public func font(_ font: UIFont) -> Self {
        merged([.font: font])
    }
}

public extension CommonAttributedString {
    /// Add attributes to string
    /// - Parameters:
    ///   - attributes: attribute dictionary for string
    ///   - target: content of the attributed string
    /// - Returns: attribute applied string
    func add(attributes: [NSAttributedString.Key: Any], to target: String) -> [CommonAttributedString] {
        string.components(separatedBy: target)
            .map { .init($0).merged(self.attributes) }
            .insert(separator: .init(target).merged(self.attributes).merged(attributes))
    }
}

public extension NSAttributedString {
    /// Add attributes to string
    /// - Parameters:
    ///   - attributes: attribute dictionary for string
    ///   - target: content of the attributed string
    /// - Returns: attribute applied string
    func add(_ attributes: [NSAttributedString.Key: Any], to target: String) -> NSAttributedString {
        let ranges = string.ranges(of: target)
        let attributedText = NSMutableAttributedString(attributedString: self)
        ranges.forEach {
            attributedText.addAttributes(attributes, range: $0)
        }
        return attributedText
    }
}

extension NSMutableAttributedString {
    func appended(with string: NSAttributedString) -> Self {
        append(string)
        return self
    }
}
