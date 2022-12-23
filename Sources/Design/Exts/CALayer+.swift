//
//  CALayer+.swift
//  Design
//
//  Created by Duc IT. Nguyen Minh on 24/05/2022.
//

import UIKit

public extension CALayer {
    struct ShadowConfiguration {
        public static let `none` = ShadowConfiguration(offSet: .zero, opacity: 0, radius: 0, color: .clear)
        public init(offSet: CGSize = .zero, opacity: Float = 0.1, radius: CGFloat = 3, color: UIColor = .black) {
            self.offSet = offSet
            self.opacity = opacity
            self.radius = radius
            self.color = color
        }

        var offSet: CGSize = .zero
        var opacity: Float = 0.2
        var radius: CGFloat = 3
        var color: UIColor = .black
    }

    @discardableResult
    func addShadow(_ config: ShadowConfiguration) -> CALayer {
        addShadow(offSet: config.offSet, opacity: config.opacity, radius: config.radius, color: config.color)
    }

    @discardableResult
    func addShadow(offSet: CGSize = .zero, opacity: Float = 0.2, radius: CGFloat = 3, color: UIColor = .black) -> CALayer {
        shadowOffset = offSet
        shadowOpacity = opacity
        shadowRadius = radius
        shadowColor = color.cgColor
        masksToBounds = false
        return self
    }

    @discardableResult
    func removeShadow() -> CALayer {
        shadowOffset = .zero
        shadowOpacity = 0
        shadowRadius = 0
        shadowColor = UIColor.clear.cgColor
        masksToBounds = false
        return self
    }
}
