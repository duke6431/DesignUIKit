//
//  String+.swift
//  DesignCore
//
//  Created by Duke Nguyen on 2024/01/07.
//
//  Extensions on `String` to provide substring range searching,
//  whitespace trimming, and first-letter capitalization utilities.
//

import Foundation

public extension String {
    /// Returns an array of `NSRange` instances representing all occurrences of the given substring.
    ///
    /// - Parameter string: The substring to search for.
    /// - Returns: An array of ranges where the substring is found within the string.
    func ranges(of string: String) -> [NSRange] {
        var indices = [Int]()
        var searchStartIndex = self.startIndex
        
        while searchStartIndex < self.endIndex,
              let range = self.range(of: string,
                                     range: searchStartIndex..<self.endIndex),
              !range.isEmpty {
            let index = distance(from: self.startIndex, to: range.lowerBound)
            indices.append(index)
            searchStartIndex = range.upperBound
        }
        
        return indices.map { NSRange(location: $0, length: string.count) }
    }
    
    /// Returns a new string by trimming leading and trailing whitespaces and newlines.
    var stripped: String { trimmingCharacters(in: .whitespacesAndNewlines) }
    
    /// Returns a new string with the first character capitalized.
    var capitalizedFirst: String {
        prefix(1).uppercased() + dropFirst()
    }
}
