//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 1/7/24.
//

import Foundation

public extension String {
    /// Search for ranges of substring from a self
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

    /// Trimming leading and trailing whitespaces and new line
    var stripped: String { trimmingCharacters(in: .whitespacesAndNewlines) }
    
    var capitalizedFirst: String {
        prefix(1).uppercased() + dropFirst()
    }
}
