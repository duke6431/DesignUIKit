//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 1/7/24.
//

import Foundation

public extension String {
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

    var stripped: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
