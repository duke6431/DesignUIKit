//
//  Date+.swift
//  DesignUIKit
//
//  Created by Duc Minh Nguyen on 1/7/24.
//
//  This file adds convenient formatting and parsing utilities
//  to `Date` and `String` types using date format strings.
//

import Foundation

public extension Date {
    /// Returns a formatted string representation of the date using the specified format.
    ///
    /// - Parameters:
    ///   - format: A date format string (e.g., "yyyy-MM-dd").
    ///   - customized: An optional closure to further configure the `DateFormatter`.
    /// - Returns: A formatted date string.
    func formatted(using format: String, _ customized: ((DateFormatter) -> DateFormatter)? = nil) -> String {
        let formatter = DateFormatter()
        formatter.locale = .autoupdatingCurrent
        formatter.dateFormat = format
        return (customized?(formatter) ?? formatter).string(from: self)
    }
}

public extension String {
    /// Parses the string into a `Date` using the specified date format.
    ///
    /// - Parameter format: The format used to parse the date string.
    /// - Returns: A `Date` if the string could be parsed; otherwise, `nil`.
    func date(using format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = .autoupdatingCurrent
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    
    /// Reformats a date string from one format to another.
    ///
    /// - Parameters:
    ///   - format: The current format of the date string.
    ///   - target: The desired output format.
    /// - Returns: A new formatted string, or `nil` if the original string cannot be parsed.
    func reformatted(from format: String, to target: String) -> String? {
        let formatter = DateFormatter()
        formatter.locale = .autoupdatingCurrent
        formatter.dateFormat = format
        guard let date = formatter.date(from: self) else { return nil }
        formatter.dateFormat = target
        return formatter.string(from: date)
    }
}
