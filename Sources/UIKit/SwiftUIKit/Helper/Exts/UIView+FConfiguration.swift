//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 2/24/24.
//

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif
import DesignCore

public extension BView {
    static var configuration = ObjectAssociation<FConfiguration>()
    
    var configuration: FConfiguration? {
        get { Self.configuration[self] }
        set { Self.configuration[self] = newValue }
    }
}
