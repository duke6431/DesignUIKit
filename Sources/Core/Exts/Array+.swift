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
}
