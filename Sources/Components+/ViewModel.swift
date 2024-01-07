//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 1/7/24.
//

import SwiftUI
import Foundation

open class ViewModel: NSObject, ObservableObject {
    @Published
    public var error: Error?
    
    @MainActor
    func load<T: Codable>(target: inout T?, value: T) {
        withAnimation { target = value }
    }
    
    @MainActor
    func load<T: Codable>(target: inout T, value: T) {
        withAnimation {
            target = value
        }
    }
    
    @MainActor
    func handle(_ error: Error) {
        withAnimation { [weak self] in
            self?.error = error
        }
    }
    
    open func discardAll() {
        fatalError("\(String(describing: self)) didn't implemented discardAll()")
    }
}
