//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 1/7/24.
//

import SwiftUI
import Foundation

public protocol ViewModeling: ObservableObject {
    var error: Error? { get set }
    func handle(_ error: Error)
    func handle(_ error: Error, customAnimation: Animation?)
}

open class ViewModel: NSObject, ViewModeling {
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
    public func handle(_ error: Error) {
        handle(error, customAnimation: nil)
    }
    
    @MainActor
    public func handle(_ error: Error, customAnimation: Animation?) {
        withAnimation(customAnimation ?? animation) { [weak self] in
            self?.error = error
        }
    }
    
    open func discardAll() {
        fatalError("\(String(describing: self)) didn't implemented discardAll()")
    }
}
