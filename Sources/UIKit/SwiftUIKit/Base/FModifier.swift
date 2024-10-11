//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 27/9/24.
//

import Foundation

public protocol FModifier<View> {
    associatedtype View: FBodyComponent
    
    @discardableResult
    func body(_ content: View) -> View
}
