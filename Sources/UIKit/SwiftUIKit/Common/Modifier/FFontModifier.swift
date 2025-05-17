//
//  FFontModifier.swift
//  ComponentSystem
//
//  Created by Duke Nguyen on 2024/02/10.
//
//  A modifier that applies a specified UIFont to any content conforming to both FBodyComponent and FCalligraphiable.
//

import UIKit

/// A modifier that applies a specified UIFont to a compatible content component.
/// The content must conform to both `FBodyComponent` and `FCalligraphiable`.
public struct FFontModifier: FModifier {
    /// The font to apply to the content.
    public var font: UIFont
    
    /// Creates a new font modifier with the given UIFont.
    /// - Parameter font: The font to apply.
    public init(font: UIFont) {
        self.font = font
    }
    
    /// Applies the font to the content if it conforms to `FCalligraphiable`.
    /// - Parameter content: The content component to modify.
    /// - Returns: The modified content with the applied font, or the original content if not applicable.
    public func body(_ content: any Content) -> any Content {
        guard let modifiedContent = content as? (FBodyComponent & FCalligraphiable) else { return content }
        return modifiedContent.font(font)
    }
}
