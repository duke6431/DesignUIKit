//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 13/10/24.
//

import Foundation
import Logging

extension Logger: SelfCustomizable { }

public protocol Loggable {
    var logger: Logger { get }
}

public extension Loggable {
    static var logger: Logger { Logger(label: String(reflecting: type(of: self))).custom { $0.logLevel = .default } }
    var logger: Logger { Logger(label: String(reflecting: type(of: self))).custom { $0.logLevel = .default } }
}

public extension Logger.Level {
    static var `default`: Self = .info
}

public extension String {
    var logMsg: Logger.Message { .init(stringLiteral: self) }
}
