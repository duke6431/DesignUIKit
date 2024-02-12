//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 1/7/24.
//

import SwiftUI
import DesignExts

public extension Color {
    init(hex: String) {
        #if os(macOS)
        self.init(nsColor: .init(hexString: hex))
        #else
        self.init(.init(hexString: hex))
        #endif
    }
}
