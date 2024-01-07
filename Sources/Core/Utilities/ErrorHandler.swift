//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 1/7/24.
//

import Foundation

public struct ErrorOption: Identifiable {
    public var id: String { title }
    
    public enum Style {
        case cancel
        case `default`
        case destructive
    }
    
    public var title: String
    public var style: Style = .default
    public var action: (() -> Void)?
    
    public init(title: String, style: Style = .default, action: (() -> Void)? = nil) {
        self.title = title
        self.style = style
        self.action = action
    }
}

public protocol SelfHandlableError {
    var title: String { get }
    var message: String { get }
    var options: [ErrorOption] { get }
}
