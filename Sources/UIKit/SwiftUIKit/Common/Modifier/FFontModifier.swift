//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 2/10/24.
//

import UIKit

public struct FFontModifier<View: FBodyComponent>: FModifier {
    public var font: UIFont

    public init(font: UIFont) {
        self.font = font
    }
    
    public func body(_ content: View) -> View {
        guard let modifiedContent = content as? (FBodyComponent & FCalligraphiable) else { return content }
        return (modifiedContent.font(font) as? View) ?? content
    }
}
