//
//  Theme+Error.swift
//  DesignUIKit
//
//  Created by Duc Minh Nguyen on 4/17/24.
//
//  Defines the `ThemeError` enumeration representing errors related to theme handling,
//  including cases for missing themes, decoding failures, and missing color palettes.
//
//  Created by Duc Minh Nguyen on 4/17/24.
//

import Foundation

/// An enumeration of errors that can occur during theme processing.
///
/// This enum represents various failure scenarios such as missing theme files,
/// decoding errors, and missing color palettes or keys.
public enum ThemeError: Error {
    /// Indicates that the theme directory is empty or missing.
    /// - Parameter subdirectory: The subdirectory path where themes were expected.
    case empty(_ subdirectory: String?)
    
    /// Indicates that a theme with the specified name was not found.
    /// - Parameter name: The name of the theme that was not found.
    case notFound(_ name: String)
    
    /// Indicates that decoding the theme failed.
    /// - Parameters:
    ///   - name: The name of the theme being decoded.
    ///   - error: The underlying error that occurred during decoding.
    case decodeFailed(_ name: String, error: Error)
    
    /// Indicates that a required color palette is missing.
    /// - Parameter name: The name of the missing palette.
    case missingPalette(_ name: String)
    
    /// Indicates that a specified color key was not found in the theme.
    /// - Parameter name: The name of the missing color key.
    case noSuchKey(_ name: String)
}

extension ThemeError: LocalizedError {
    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        switch self {
        case .empty(let subdirectory):
            return "Theme are not found in \(subdirectory ?? "/") of selected bundle"
        case .notFound(let name):
            return "Theme \(name) not found"
        case .decodeFailed(let name, let error):
            return "Decoding theme \(name) failed with error:\n\(error.localizedDescription)"
        case .missingPalette(let name):
            return "Missing \(name) palette"
        case .noSuchKey(let name):
            return "Color key \(name) not found"
        }
    }
}
