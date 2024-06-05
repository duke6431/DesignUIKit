//
//  CCATextLayer.swift
//
//
//  Created by Duc Minh Nguyen on 6/5/24.
//

import QuartzCore
import Foundation

/// Vertical Centerized Text Layer
class CCATextLayer: CATextLayer {
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
#if canImport(UIKit)
        ctx.translateBy(x: 0.0, y: yDiff)
#else
        ctx.translateBy(x: 0.0, y: -yDiff)
#endif
        super.draw(in: ctx)
        ctx.restoreGState()
    }
}
