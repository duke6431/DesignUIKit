//
//  Representables.swift
//  DesignCore
//
//  Created by Duke Nguyen on 2024/03/27.
//
//  Defines protocols and enums for providing image representations,
//  including system and asset-based image sources.
//

import UIKit

/// A protocol that represents an entity capable of providing a `UIImage`.
public protocol ImageRepresenting {
    /// The image associated with this representer.
    var image: UIImage? { get }
}

/// An enumeration that provides different ways to represent an image.
///
/// - system: Represents a system image identified by its name.
/// - asset: Represents an image asset from a specified bundle.
public enum ImageRepresenter: ImageRepresenting {
    /// Represents a system image identified by its name.
    case system(name: String)
    /// Represents an image asset from a specified bundle.
    case asset(name: String, bundle: Bundle = .main)
    
    /// The `UIImage` instance associated with the representer.
    ///
    /// For `.system`, returns the system image with the given name.
    /// For `.asset`, returns the image asset from the specified bundle.
    public var image: UIImage? {

        switch self {
        case .system(let name):
            return .init(systemName: name)
        case .asset(let name, let bundle):
            return .init(named: name, in: bundle, with: .none)
        }
    }
}
