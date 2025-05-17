//
//  Loggable.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 13/10/24.
//

import Foundation
import Logging

/// A protocol that provides a logger instance for conforming types.
public protocol Loggable {
    /// A logger used for logging messages.
    var logger: Logger { get }
}

public extension Loggable {
    /// A default logger instance for the conforming type.
    static var logger: Logger { Logger(label: String(reflecting: type(of: self))).custom { $0.logLevel = .default } }
    /// A default logger instance for the conforming type.
    var logger: Logger { Logger(label: String(reflecting: type(of: self))).custom { $0.logLevel = .default } }
}

/// Extension to provide a default log level for `Logger.Level`.
public extension Logger.Level {
    /// The default log level used throughout the system.
    static var `default`: Self = .info
}

/// Extension to convert a `String` to a `Logger.Message`.
public extension String {
    /// Converts the string to a `Logger.Message` for logging.
    var logMsg: Logger.Message { .init(stringLiteral: self) }
}

extension Logger: SelfCustomizable { }
