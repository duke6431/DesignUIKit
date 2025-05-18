//
//  Array+.swift
//  DesignCore
//
//  Created by Duke Nguyen on 2024/01/07.
//
//  Adds safe subscripting, separator interleaving, and inverse filtering
//  utilities to `Array` via extension.
//
import Foundation

public extension Array {
    /// Safely accesses the element at the specified index.
    ///
    /// This subscript returns `nil` if the index is out of bounds.
    ///
    /// - Parameter index: The index of the element to access.
    /// - Returns: The element at the specified index if it is within bounds; otherwise, `nil`.
    subscript(safe index: Int) -> Element? {
        guard index > -1, index < count else { return nil }
        return self[index]
    }
    
    /// Returns a new array with the given separator inserted between each element of the array.
    ///
    /// - Parameter separator: The element to insert between each element of the array.
    /// - Returns: A new array with the separator interleaved between elements.
    func insert(separator: Element) -> [Element] {
        (0 ..< 2 * count - 1).map { $0 % 2 == 0 ? self[$0/2] : separator }
    }
    
    /// Returns an array containing the elements that do not satisfy the given predicate.
    ///
    /// This is the inverse of the standard `filter(_:)` method.
    ///
    /// - Parameter isIncluded: A closure that takes an element and returns `true` if the element should be excluded.
    /// - Returns: An array of elements for which `isIncluded` returns `false`.
    @inlinable func invertFilter(_ isIncluded: (Element) throws -> Bool) rethrows -> [Element] {
        try filter { try !isIncluded($0) }
    }
}
