//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 1/7/24.
//

import SwiftUI
import Foundation

open class ViewModel: NSObject, ObservableObject {
    public static var animation = Animation.easeInOut(duration: 0.25)
    
    @Published
    public var error: Error?
    public var animation = ViewModel.animation
    
    @MainActor
    public func load<T: Codable>(target: inout T?, value: T, customAnimation: Animation? = nil) {
        withAnimation(customAnimation ?? animation) { target = value }
    }
    
    @MainActor
    public func load<T: Codable>(target: inout T, value: T, customAnimation: Animation? = nil) {
        withAnimation(customAnimation ?? animation) {
            target = value
        }
    }
    
    @MainActor
    public func handle(_ error: Error, customAnimation: Animation? = nil) {
        withAnimation(customAnimation ?? animation) { [weak self] in
            self?.error = error
        }
    }
    
    open func discardAll() {
        fatalError("\(String(describing: self)) didn't implemented discardAll()")
    }
}
