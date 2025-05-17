//
//  File.swift
//  ComponentSystem
//
//  Created by Duke Nguyen on 1/10/24.
//

import Foundation

extension TestFailure: LocalizedError {
    public var errorDescription: String? {
        var description: String = ""
        description += "[Type] \(type.title)"
        if let note { description += " - \(note)" }
        if let underlyingError { description += "\n\tUnderlying error: \(underlyingError.localizedDescription)" }
        return description
    }
}
