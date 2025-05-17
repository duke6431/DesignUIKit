//
//  CommonAttributedString.swift
//  DesignCore
//
//  Created by Duke Nguyen on 2022/06/13.
//
//  Provides utilities and protocols to build and manipulate attributed strings
//  with a fluent and chainable interface.
//

import UIKit

/// Protocol that requires a built NSMutableAttributedString representation.
public protocol AttributedStringBuildable {
    /// The constructed NSMutableAttributedString
    var built: NSMutableAttributedString { get }
}

public extension NSAttributedString {
    /// Builds an NSAttributedString from a list of `AttributedStringBuildable` components.
    ///
    /// - Parameter strings: A result builder producing an array of `AttributedStringBuildable`.
    /// - Returns: A combined NSAttributedString by appending each component's built attributed string.
    static func build(@FBuilder<AttributedStringBuildable> _ strings: () -> [AttributedStringBuildable]) -> NSAttributedString {
        strings().reduce(NSMutableAttributedString()) { $0.appended(with: $1.built) }
    }
}

extension CommonAttributedString: AttributedStringBuildable {
    /// Returns an NSMutableAttributedString with the string and its attributes.
    public var built: NSMutableAttributedString {
        NSMutableAttributedString(string: string, attributes: attributes)
    }
}

extension Array: AttributedStringBuildable where Element == CommonAttributedString {
    /// Combines an array of `CommonAttributedString` into one NSMutableAttributedString.
    public var built: NSMutableAttributedString {
        reduce(.init()) {
            $0.appended(with: $1.built)
        }
    }
}

/// A chainable attributed string wrapper to build and modify attributed strings.
public class CommonAttributedString: Chainable {
    /// The dictionary of NSAttributedString attributes applied to the string.
    public var attributes: [NSAttributedString.Key: Any] = [:]
    
    /// The underlying string value.
    public var string: String
    
    /// Initializes with an optional string.
    /// - Parameter string: The base string.
    public init(_ string: String = "") {
        self.string = string
    }
    
    /// Merges new attributes into the existing ones, replacing duplicates.
    /// - Parameter attributes: Attributes to merge.
    /// - Returns: Self for chaining.
    public func merged(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        self.attributes.merge(attributes) { _, second in second }
        return self
    }
    
    /// Applies a foreground (text) color attribute.
    /// - Parameter color: UIColor to apply.
    /// - Returns: Self for chaining.
    public func foreground(_ color: UIColor) -> Self {
        merged([.foregroundColor: color])
    }
    
    /// Applies a background color attribute.
    /// - Parameter color: UIColor to apply.
    /// - Returns: Self for chaining.
    public func background(_ color: UIColor) -> Self {
        merged([.backgroundColor: color])
    }
    
    /// Applies a font attribute.
    /// - Parameter font: UIFont to apply.
    /// - Returns: Self for chaining.
    public func font(_ font: UIFont) -> Self {
        merged([.font: font])
    }
}

public extension CommonAttributedString {
    /// Adds attributes to all occurrences of a target substring.
    ///
    /// - Parameters:
    ///   - attributes: Attributes to add.
    ///   - target: The substring to apply attributes to.
    /// - Returns: An array of `CommonAttributedString` with attributes applied to target substrings.
    func add(attributes: [NSAttributedString.Key: Any], to target: String) -> [CommonAttributedString] {
        string.components(separatedBy: target)
            .map { .init($0).merged(self.attributes) }
            .insert(separator: .init(target).merged(self.attributes).merged(attributes))
    }
}

public extension NSAttributedString {
    /// Adds attributes to all occurrences of a target substring in the attributed string.
    ///
    /// - Parameters:
    ///   - attributes: Attributes to add.
    ///   - target: The substring to apply attributes to.
    /// - Returns: A new NSAttributedString with attributes applied to the target substrings.
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
    /// Appends another NSAttributedString and returns self for chaining.
    /// - Parameter string: The NSAttributedString to append.
    /// - Returns: Self after appending.
    func appended(with string: NSAttributedString) -> Self {
        append(string)
        return self
    }
}
