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

public protocol FAssignable {
    func assign<View: FBodyComponent>(to target: inout View?) -> View
}

public extension FAssignable {
    func assign<View: FBodyComponent>(to target: inout View?) -> View {
        target = self as? View
        return self as! View
    }
}
