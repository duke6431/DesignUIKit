//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 4/17/24.
//

import Foundation
import DesignCore
import UIKit

public extension Theme {
    static func scan(bundle: Bundle, subdirectory: String? = nil) throws -> [Theme] {
        guard let paths = bundle.urls(forResourcesWithExtension: "json", subdirectory: subdirectory) else {
            throw ThemeError.empty(subdirectory)
        }
        return paths.map { ($0, $0.lastPathComponent) }.compactMap {
            do {
                return try load(from: $0, name: $1)
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
    }
    
    static func scan(_ directory: URL) throws -> [Theme] {
        guard let themes = FileManager.default.enumerator(atPath: directory.absoluteString)?.compactMap({ element -> (URL, String)? in
            guard let path = element as? String, let url = URL(string: path) else { return nil }
            return (url, url.lastPathComponent)
        }).compactMap({
            do {
                return try load(from: $0, name: $1)
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }) else {
            throw ThemeError.empty(directory.absoluteString)
        }
        return themes
    }
    
    static func load(from bundle: Bundle, subdirectory: String? = nil, name: String) throws -> Theme {
        guard let path = bundle.urls(forResourcesWithExtension: "json", subdirectory: subdirectory)?.first(where: {
            $0.lastPathComponent.contains(name)
        }) else {
            throw ThemeError.notFound(name)
        }
        return try load(from: path, name: name)
    }
    
    static func load(from path: URL, name: String) throws -> Theme {
        do {
            return try JSONDecoder().decode(Theme.self, from: try Data(contentsOf: path))
        } catch {
            throw ThemeError.decodeFailed(name, error: error)
        }
    }
}

extension UIUserInterfaceStyle {
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

extension BImage {
    /// Creates a dynamic image that supports displaying a different image asset when dark mode is active.
    convenience init?(dynamicImageWithLight makeLight: @autoclosure () -> BImage?,
                      dark makeDark: @autoclosure () -> BImage?
    ) {
        self.init()
        guard let lightImg = makeLight(), let darkImg = makeDark() else { return nil }
        self.imageAsset?.register(lightImg, with: UITraitCollection(userInterfaceStyle: .light))
        self.imageAsset?.register(darkImg, with: UITraitCollection(userInterfaceStyle: .dark))
    }
}
