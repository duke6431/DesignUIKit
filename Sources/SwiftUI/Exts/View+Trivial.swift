//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 1/7/24.
//

import SwiftUI
import Foundation

public extension View {
    #if os(iOS) || os(tvOS)
    @ViewBuilder
    func navigationBar(hidden: Bool) -> some View {
        if #available(iOS 16.0, *) {
            toolbar(hidden ? .hidden : .automatic , for: .navigationBar)
        } else {
            navigationBarHidden(true)
        }
    }
    
    func attachDismissKeyboard() -> some View {
        onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    #endif
}
