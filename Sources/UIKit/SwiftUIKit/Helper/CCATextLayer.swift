//
//  CCATextLayer.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2024/06/05.
//
//  A custom CATextLayer subclass that vertically centers text within its bounds.
//

import QuartzCore
import Foundation

/// A custom `CATextLayer` subclass that adjusts its rendering context
/// to vertically center text inside the layer's bounds.
class CCATextLayer: CATextLayer {
    /// Overrides the default drawing method to translate the text context
    /// vertically so that the text is centered within the layer.
    /// - Parameter ctx: The graphics context in which to draw the text.
    override open func draw(in ctx: CGContext) {
        let yDiff: CGFloat
        let fontSize: CGFloat
        let height = self.bounds.height
        
        if let attributedString = self.string as? NSAttributedString {
            fontSize = attributedString.size().height
            yDiff = (height-fontSize)/2
        } else {
            fontSize = self.fontSize
            yDiff = (height-fontSize)/2 - fontSize/10
        }
        
        ctx.saveGState()
        ctx.translateBy(x: 0.0, y: yDiff)
        
        super.draw(in: ctx)
        ctx.restoreGState()
    }
}
