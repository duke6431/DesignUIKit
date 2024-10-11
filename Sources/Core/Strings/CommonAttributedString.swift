//
//  CommonAttributedString.swift
//  Core
//
//  Created by Duc IT. Nguyen Minh on 13/06/2022.
//

import UIKit

public class CommonAttributedString: Chainable {
    public var attributes: [NSAttributedString.Key: Any] = [:]
    public var string: String

    public init(_ string: String = "") {
        self.string = string
    }
    
    /// Build metadata into NSAttributedString
    /// - Returns: Swift attributed string
    public func build() -> NSAttributedString {
        NSMutableAttributedString(string: string, attributes: attributes)
    }
    
    /// Existed key-value will be replaced
    public func merged(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        self.attributes.merge(attributes) { _, second in second }
        return self
    }
    
    /// build function to create NSAttributedString
    /// - Parameter strings: builder into list of common attributed string
    /// - Returns: a sumarized attributed string
    public static func build(@FBuilder<CommonAttributedString> _ strings: () -> [CommonAttributedString]) -> NSAttributedString {
        strings().reduce(into: NSMutableAttributedString()) { partialResult, prototype in
            partialResult.append(prototype.build())
        }
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

public extension NSAttributedString {
    static func build(@FBuilder<CommonAttributedString> _ strings: () -> [CommonAttributedString]) -> NSAttributedString {
        strings().reduce(into: NSMutableAttributedString()) { partialResult, prototype in
            partialResult.append(prototype.build())
        }
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
