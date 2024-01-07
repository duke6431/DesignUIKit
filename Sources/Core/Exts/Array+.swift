//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 1/7/24.
//

import Foundation

public extension Array {
    subscript(safe index: Int) -> Element? {
        guard index < count else { return nil }
        return self[index]
    }
}
