//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 1/7/24.
//

import SwiftUI

public extension Image {
    @ViewBuilder
    func resizable(width: CGFloat, height: CGFloat? = nil, contentMode: ContentMode = .fit) -> some View {
        resizable().aspectRatio(contentMode: contentMode).frame(width: width, height: height ?? width)
    }
}
