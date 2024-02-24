//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 2/24/24.
//

import UIKit
import DesignCore

public extension UIView {
    static var configuration = ObjectAssociation<FConfiguration>()
    
    var configuration: FConfiguration? {
        get { Self.configuration[self] }
        set { Self.configuration[self] = newValue }
    }
}
