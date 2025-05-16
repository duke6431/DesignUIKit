//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 1/7/24.
//

import Foundation

public extension Array {
    /// Safely select element of array
    /// Usage:
    ///     `var optionalInt = array[safe: 1]`
    subscript(safe index: Int) -> Element? {
        guard index > -1, index < count else { return nil }
        return self[index]
    }

    func insert(separator: Element) -> [Element] {
        (0 ..< 2 * count - 1).map { $0 % 2 == 0 ? self[$0/2] : separator }
    }
    
    @inlinable func invertFilter(_ isIncluded: (Element) throws -> Bool) rethrows -> [Element] {
        try filter { try !isIncluded($0) }
    }
}
