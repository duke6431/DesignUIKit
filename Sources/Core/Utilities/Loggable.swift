//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 13/10/24.
//

import Foundation
import Logging

public protocol Loggable {
    var logger: Logger { get }
}

public extension Loggable {
    var logger: Logger { Logger(label: String(reflecting: type(of: self))) }
}

public extension String {
    var log: Logger.Message { .init(stringLiteral: self) }
}
