//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 2/10/24.
//

import UIKit

public struct FFontModifier: FModifier {
    public var font: UIFont

    public init(font: UIFont) {
        self.font = font
    }
    
    public func body(_ content: any Content) -> any Content {
        guard let modifiedContent = content as? (FBodyComponent & FCalligraphiable) else { return content }
        return modifiedContent.font(font)
    }
}
