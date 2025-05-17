//
//  Theme+.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2024/04/17.
//
//  Extension for the `Theme` type providing methods to scan and load theme JSON files
//  from bundles and directories, and a mapping from `UIUserInterfaceStyle` to `Theme.Style`.
//

import Foundation
import DesignCore
import FileKit
import UIKit

public extension Theme {
    /// Scans the specified bundle for theme JSON files, optionally within a subdirectory, and loads them as Theme instances.
    ///
    /// - Parameters:
    ///   - bundle: The bundle to scan for theme JSON files.
    ///   - subdirectory: An optional subdirectory within the bundle to search.
    /// - Throws: `ThemeError.empty` if no JSON files are found in the specified location.
    /// - Returns: An array of loaded `Theme` objects.
    static func scan(bundle: Bundle, subdirectory: String? = nil) throws -> [Theme] {
        guard let paths = bundle.urls(forResourcesWithExtension: "json", subdirectory: subdirectory) else {
            throw ThemeError.empty(subdirectory)
        }
        return paths.map { ($0, $0.lastPathComponent) }.compactMap {
            do {
                return try load(from: $0, name: $1)
            } catch {
                logger.error(error.localizedDescription.logMsg)
                return nil
            }
        }
    }
    
    /// Scans the specified directory for theme JSON files and loads them as Theme instances.
    ///
    /// - Parameter directory: The directory path to scan for theme JSON files.
    /// - Throws: Propagates errors thrown during loading of themes.
    /// - Returns: An array of loaded `Theme` objects.
    static func scan(_ directory: Path) throws -> [Theme] {
        directory.compactMap({ elem in (elem, elem.fileName) }).compactMap({
            do {
                return try load(from: $0.url, name: $1)
            } catch {
                logger.error(error.localizedDescription.logMsg)
                return nil
            }
        })
    }
    
    /// Loads a `Theme` instance from a JSON file in the specified bundle and optional subdirectory by name.
    ///
    /// - Parameters:
    ///   - bundle: The bundle containing the JSON file.
    ///   - subdirectory: An optional subdirectory within the bundle.
    ///   - name: The name of the theme file to load.
    /// - Throws: `ThemeError.notFound` if the file is not found, or `ThemeError.decodeFailed` if decoding fails.
    /// - Returns: The loaded `Theme` object.
    static func load(from bundle: Bundle, subdirectory: String? = nil, name: String) throws -> Theme {
        guard let path = bundle.urls(forResourcesWithExtension: "json", subdirectory: subdirectory)?.first(where: {
            $0.lastPathComponent.contains(name)
        }) else {
            throw ThemeError.notFound(name)
        }
        return try load(from: path, name: name)
    }
    
    /// Loads a `Theme` instance from a JSON file at the specified URL.
    ///
    /// - Parameters:
    ///   - path: The URL of the JSON file.
    ///   - name: The name of the theme.
    /// - Throws: `ThemeError.decodeFailed` if decoding fails.
    /// - Returns: The loaded `Theme` object.
    static func load(from path: URL, name: String) throws -> Theme {
        do {
            return try JSONDecoder().decode(Theme.self, from: try Data(contentsOf: path))
        } catch {
            throw ThemeError.decodeFailed(name, error: error)
        }
    }
}

extension UIUserInterfaceStyle {
    /// Maps the `UIUserInterfaceStyle` to the corresponding `Theme.Style`.
    ///
    /// - Returns: `.light` for `.light` and `.unspecified` styles, `.dark` for `.dark` style.
    var style: Theme.Style {
        switch self {
        case .light, .unspecified:
            return .light
        case .dark:
            return .dark
        @unknown default:
            return .light
        }
    }
}
