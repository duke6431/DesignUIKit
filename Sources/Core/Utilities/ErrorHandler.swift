//
//  ErrorHandler.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2024/01/07.
//
//  This file defines error handling utilities including the `ErrorOption` struct
//  representing actionable options for errors and the `SelfHandlableError` protocol
//  describing errors with titles, messages, options, and additional metadata.
//

import Foundation

/// Represents an actionable option for an error, such as a button in an alert.
public struct ErrorOption: Identifiable {
    /// A unique identifier for the error option, derived from the title.
    public var id: String { title }
    
    /// Style of the error option, indicating its role or importance.
    public enum Style {
        /// A cancel action style.
        case cancel
        /// A default action style.
        case `default`
        /// A destructive action style (e.g., delete).
        case destructive
    }
    
    /// The title displayed for the error option.
    public var title: String
    
    /// The style of the option, defaults to `.default`.
    public var style: Style = .default
    
    /// An optional closure executed when the option is selected.
    public var action: (() -> Void)?
    
    /// Initializes an `ErrorOption`.
    /// - Parameters:
    ///   - title: The display title of the option.
    ///   - style: The style of the option, defaults to `.default`.
    ///   - action: An optional closure to execute when selected.
    public init(title: String, style: Style = .default, action: (() -> Void)? = nil) {
        self.title = title
        self.style = style
        self.action = action
    }
}

/// Protocol defining an error that can handle itself with title, message, and options.
public protocol SelfHandlableError {
    /// The title describing the error.
    var title: String { get }
    
    /// The detailed message of the error.
    var message: String { get }
    
    /// The actionable options available for the error.
    var options: [ErrorOption] { get }
    
    /// Optional additional information as a dictionary.
    var additional: [String: Any]? { get }
}
