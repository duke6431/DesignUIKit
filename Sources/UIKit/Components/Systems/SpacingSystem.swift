//
//  SpacingSystem.swift
//
//  A centralized system for managing consistent spacing values throughout the application.
//  Provides a scalable spacing solution with support for multiplier adjustments.
//
//  Created by Duc IT. Nguyen Minh on 10/01/2024.
//

import Foundation

/// A singleton class that manages spacing values for UI layout.
/// 
/// `SpacingSystem` provides a centralized way to define and retrieve consistent spacing
/// values, which can be scaled using a multiplier. This helps maintain uniform spacing
/// across the application and supports dynamic adjustments based on design requirements.
public class SpacingSystem {
    /// The shared singleton instance of `SpacingSystem`.
    public static let shared = SpacingSystem()
    
    /// A multiplier that scales the base spacing values.
    /// This allows for easy adjustment of spacing sizes globally.
    var multiplier: Multiplier = .init(1)
    
    /// Initializes a new instance of `SpacingSystem`.
    /// This is private to enforce the singleton pattern.
    init() { }
    
    /// Returns the scaled spacing value for the given `CommonSpacing` type.
    ///
    /// - Parameter type: The base spacing value to be scaled.
    /// - Returns: The spacing value multiplied by the current multiplier.
    public func spacing(_ type: CommonSpacing) -> CGFloat {
        type.value * multiplier.value
    }
}

public extension SpacingSystem {
    /// Represents a base spacing value used within the `SpacingSystem`.
    ///
    /// Use this struct to define consistent spacing units that can be scaled by the multiplier.
    struct CommonSpacing {
        /// The base spacing value.
        var value: CGFloat
        
        /// Creates a new `CommonSpacing` instance with the given value.
        ///
        /// - Parameter value: The base spacing value.
        public init(_ value: CGFloat) { self.value = value }
    }
    
    /// Represents a multiplier used to scale spacing values globally.
    ///
    /// Adjusting this multiplier will proportionally scale all spacing values returned by the system.
    struct Multiplier {
        /// The multiplier value.
        var value: CGFloat
        
        /// Creates a new `Multiplier` instance with the given value.
        ///
        /// - Parameter value: The multiplier to apply to base spacing values.
        public init(_ value: CGFloat) { self.value = value }
    }
}
