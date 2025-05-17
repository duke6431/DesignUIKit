//
//  Optional+.swift
//  DesignCore
//
//  Created by Duke Nguyen on 2024/11/10.
//
//  Extensions on `Optional` to simplify type casting and collection emptiness checks.
//

import Foundation

extension Optional {
    /// Attempts to cast the wrapped optional value to a specified type.
    ///
    /// - Parameter kind: The type to cast to.
    /// - Returns: The casted value if successful; otherwise, `nil`.
    func cast<NewType>(to kind: NewType.Type) -> NewType? {
        self as? NewType
    }
}

extension Optional where Wrapped: Collection {
    /// Indicates whether the wrapped collection is empty or `nil`.
    ///
    /// Returns `true` if the optional is `nil` or the collection is empty.
    var isEmpty: Bool {
        self?.isEmpty ?? true
    }
}
