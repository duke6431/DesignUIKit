//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 18/01/2024.
//

import SwiftUI

extension Text {
#if os(iOS)
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

extension View {
#if os(iOS)
    @ViewBuilder
    func foreground(_ color: UIColor) -> some View {
        foregroundStyle(Color(color))
    }
#elseif os(macOS)
    @ViewBuilder
    func foreground(_ color: NSColor) -> some View {
        foregroundStyle(Color(color))
    }
#endif
}
