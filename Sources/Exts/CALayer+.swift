//
//  CALayer+.swift
//  Design
//
//  Created by Duc IT. Nguyen Minh on 24/05/2022.
//

import UIKit
import DesignCore

public extension CALayer {
    /// A configuration object for view's shadow
    struct ShadowConfiguration: SelfCustomizable {
        public static let `none` = ShadowConfiguration(offSet: .zero, opacity: 0, radius: 0, color: .clear)
        public init(offSet: CGSize = .zero, opacity: Float = 0.3,
                    radius: CGFloat = 6, color: BColor = .black,
                    targetRect: CGRect? = nil) {
            self.offSet = offSet
            self.opacity = opacity
            self.radius = radius
            self.color = color
            if let targetRect {
                self.path = UIBezierPath(rect: targetRect).cgPath
            }
        }
        
        public var offSet: CGSize = .zero
        public var opacity: Float = 0.2
        public var radius: CGFloat = 3
        public var color: BColor = .black
        public var path: CGPath? = nil
    }
    
    /// Add shadow to view with a configuration
    /// - Parameter config: Shadow configuration. Can use `.none` for no shadow
    /// - Returns: Current layer
    @discardableResult func add(shadow config: ShadowConfiguration) -> CALayer {
        addShadow(offSet: config.offSet, opacity: config.opacity, radius: config.radius, color: config.color, path: config.path)
    }
    
    /// Base function to add shadow, returning current layer
    @discardableResult func addShadow(
        offSet: CGSize = .zero, opacity: Float = 0.2,
        radius: CGFloat = 3, color: BColor = .black, path: CGPath? = nil
    ) -> CALayer {
        if let path {
            shadowPath = path
        }
        shadowOffset = offSet
        shadowOpacity = opacity
        shadowRadius = radius
        shadowColor = color.cgColor
        masksToBounds = false
        return self
    }
    
    /// Base function to remove shadow from view
    @discardableResult
    func removeShadow() -> CALayer {
        shadowPath = nil
        shadowOffset = .zero
        shadowOpacity = 0
        shadowRadius = 0
        shadowColor = BColor.clear.cgColor
        masksToBounds = false
        return self
    }
}
