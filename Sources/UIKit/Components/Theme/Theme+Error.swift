//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 4/17/24.
//

import Foundation

public enum ThemeError: Error {
    case empty(_ subdirectory: String?)
    case notFound(_ name: String)
    case decodeFailed(_ name: String, error: Error)
}

extension ThemeError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .empty(let subdirectory):
            return "Theme are not found in \(subdirectory ?? "/") of selected bundle"
        case .notFound(let name):
            return "Theme \(name) not found"
        case .decodeFailed(let name, let error):
            return "Decoding theme \(name) failed with error:\n\(error.localizedDescription)"
        }
    }
}
