//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 4/23/24.
//

import Foundation

extension Error where Self: MPresentable {
    var messageDescription: String? { localizedDescription }
    
    var presentationStyle: MPresentationStyle { .center }
}

typealias MInfo = Error
typealias MWarning = Error
typealias MError = Error
