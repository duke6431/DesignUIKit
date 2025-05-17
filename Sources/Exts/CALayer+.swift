//
//  CALayer+.swift
//  Design
//
//  Created by Duc IT. Nguyen Minh on 24/05/2022.
//
//  This file provides an extension to CALayer that simplifies the configuration and management of shadows.
//  It includes a ShadowConfiguration struct for encapsulating shadow parameters and convenience methods
//  to add or remove shadows from a CALayer instance.
//

import UIKit
import DesignCore

public extension CALayer {
    /// A configuration object encapsulating the parameters for a layer's shadow.
    ///
    /// This struct provides a convenient way to specify shadow properties such as offset, opacity,
    /// radius, color, and an optional shadow path. It conforms to `SelfCustomizable` to support default
    /// and custom shadow configurations.
    struct ShadowConfiguration: SelfCustomizable {
        /// A predefined shadow configuration representing no shadow.
        ///
        /// This configuration has zero offset, zero opacity, zero radius, and a clear color.
        public static let `none` = ShadowConfiguration(offSet: .zero, opacity: 0, radius: 0, color: .clear)
        
        /// Creates a new shadow configuration with the specified parameters.
        ///
        /// - Parameters:
        ///   - offSet: The offset of the shadow. Defaults to `.zero`.
        ///   - opacity: The opacity of the shadow, ranging from 0 (transparent) to 1 (opaque). Defaults to 0.3.
        ///   - radius: The blur radius used to create the shadow. Defaults to 6.
        ///   - color: The color of the shadow. Defaults to `.black`.
        ///   - targetRect: An optional rectangle to define the shadow path. If provided, the shadow path will be set to this rectangle.
        public init(offSet: CGSize = .zero, opacity: Float = 0.3,
                    radius: CGFloat = 6, color: UIColor = .black,
                    targetRect: CGRect? = nil) {
            self.offSet = offSet
            self.opacity = opacity
            self.radius = radius
            self.color = color
            if let targetRect {
                self.path = UIBezierPath(rect: targetRect).cgPath
            }
        }
        
        /// The offset of the shadow from the layer.
        ///
        /// Defaults to `.zero`.
        public var offSet: CGSize = .zero
        
        /// The opacity of the shadow.
        ///
        /// A value between 0 (transparent) and 1 (opaque). Defaults to 0.2.
        public var opacity: Float = 0.2
        
        /// The blur radius used to create the shadow.
        ///
        /// Defaults to 3.
        public var radius: CGFloat = 3
        
        /// The color of the shadow.
        ///
        /// Defaults to `.black`.
        public var color: UIColor = .black
        
        /// An optional shadow path to improve rendering performance and define the shape of the shadow.
        ///
        /// Defaults to `nil`.
        public var path: CGPath? = nil
    }
    
    /// Adds a shadow to the layer using the specified shadow configuration.
    ///
    /// - Parameter config: The shadow configuration to apply. Use `.none` to remove any shadow.
    /// - Returns: The current layer instance, allowing for method chaining.
    @discardableResult func add(shadow config: ShadowConfiguration) -> CALayer {
        addShadow(offSet: config.offSet, opacity: config.opacity, radius: config.radius, color: config.color, path: config.path)
    }
    
    /// Adds a shadow to the layer with detailed shadow parameters.
    ///
    /// - Parameters:
    ///   - offSet: The offset of the shadow. Defaults to `.zero`.
    ///   - opacity: The opacity of the shadow, ranging from 0 (transparent) to 1 (opaque). Defaults to 0.2.
    ///   - radius: The blur radius used to create the shadow. Defaults to 3.
    ///   - color: The color of the shadow. Defaults to `.black`.
    ///   - path: An optional shadow path to improve rendering performance and define the shape of the shadow. Defaults to `nil`.
    /// - Returns: The current layer instance, allowing for method chaining.
    @discardableResult func addShadow(
        offSet: CGSize = .zero, opacity: Float = 0.2,
        radius: CGFloat = 3, color: UIColor = .black, path: CGPath? = nil
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
    
    /// Removes any shadow from the layer.
    ///
    /// This method resets the shadow properties to default values, effectively removing the shadow.
    ///
    /// - Returns: The current layer instance, allowing for method chaining.
    @discardableResult
    func removeShadow() -> CALayer {
        shadowPath = nil
        shadowOffset = .zero
        shadowOpacity = 0
        shadowRadius = 0
        shadowColor = UIColor.clear.cgColor
        masksToBounds = false
        return self
    }
}
