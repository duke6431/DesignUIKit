//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 18/01/2024.
//

import SwiftUI

public extension Text {
#if os(iOS) || os(tvOS)
    @ViewBuilder
    func font(_ style: UIFont) -> Text {
        font(.init(style))
    }
#elseif os(macOS)
    @ViewBuilder
    func font(_ style: NSFont) -> Text {
        font(.init(style))
    }
#endif
}

public extension View {
#if os(iOS) || os(tvOS)
    @ViewBuilder
    func foregroundStyle(_ statusColorOff: UIColor) -> some View {
        foregroundStyle(Color(statusColorOff))
    }
#elseif os(macOS)
    @ViewBuilder
    func foregroundStyle(_ statusColorOff: NSColor) -> some View {
        foregroundStyle(Color(statusColorOff))
    }
#endif
    
    
}
