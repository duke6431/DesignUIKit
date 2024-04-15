//
//  CommonAttributedString.swift
//  Core
//
//  Created by Duc IT. Nguyen Minh on 13/06/2022.
//

import Foundation

public class CommonAttributedString {
    public var attributes: [NSAttributedString.Key: Any] = [:]
    public var string: String

    public init(_ string: String = "") {
        self.string = string
    }
    
    public func build() -> NSAttributedString {
        NSMutableAttributedString(string: string, attributes: attributes)
    }
    
    /// Existed key-value will be replaced
    public func merged(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        self.attributes.merge(attributes) { _, second in second }
        return self
    }

    // swiftlint:disable:next line_length
    public static func build(@FBuilder<CommonAttributedString> _ strings: () -> [CommonAttributedString]) -> NSAttributedString {
        strings().reduce(into: NSMutableAttributedString()) { partialResult, prototype in
            partialResult.append(prototype.build())
        }
    }
    
    func foreground(_ color: BColor) -> Self {
        merged([.foregroundColor: color])
    }
    
    func background(_ color: BColor) -> Self {
        merged([.backgroundColor: color])
    }
    
    func font(_ font: BFont) -> Self {
        merged([.font: font])
    }
}

public extension NSAttributedString {
    func add(_ attributes: [NSAttributedString.Key: Any], to target: String) -> NSAttributedString {
        let ranges = string.ranges(of: target)
        let attributedText = NSMutableAttributedString(attributedString: self)
        ranges.forEach {
            attributedText.addAttributes(attributes, range: $0)
        }
        return attributedText
    }
}
