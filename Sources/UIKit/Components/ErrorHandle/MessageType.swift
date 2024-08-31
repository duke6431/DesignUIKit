//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 4/23/24.
//

import Foundation

public extension Error where Self: MPresentable {
    var messageDescription: String? { localizedDescription }
    
    var presentationStyle: MPresentationStyle { .center }
}

public typealias MInfo = Error
public typealias MWarning = Error
public typealias MError = Error
