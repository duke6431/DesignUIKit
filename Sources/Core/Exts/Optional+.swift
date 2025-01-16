//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 11/10/24.
//

import Foundation

extension Optional {
    func cast<NewType>(to kind: NewType.Type) -> NewType? {
        self as? NewType
    }
}

extension Optional where Wrapped: Collection {
    var isEmpty: Bool {
        self?.isEmpty ?? true
    }
}
