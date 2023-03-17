//
//  CommonAttributedString.swift
//  Core
//
//  Created by Duc IT. Nguyen Minh on 13/06/2022.
//

import UIKit

public class CommonAttributedString {
    var attributes: [NSAttributedString.Key: Any] = [:]
    var string: String

    init(_ string: String = "") {
        self.string = string
    }

    public func background(with color: UIColor) -> Self {
        attributes[.backgroundColor] = color
        return self
    }
    public func foreground(with color: UIColor) -> Self {
        attributes[.foregroundColor] = color
        return self
    }
    public func font(with font: UIFont) -> Self {
        attributes[.font] = font
        return self
    }

    public func build() -> NSAttributedString {
        return NSMutableAttributedString(string: string, attributes: attributes)
    }

    // swiftlint:disable:next line_length
    public static func build(@BuilderComponent<CommonAttributedString> _ strings: () -> [CommonAttributedString]) -> NSAttributedString {
        strings().reduce(into: NSMutableAttributedString()) { partialResult, prototype in
            partialResult.append(prototype.build())
        }
    }
}
