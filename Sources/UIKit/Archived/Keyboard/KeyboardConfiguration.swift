//
//  KeyboardConfiguration.swift
//  Components
//
//  Created by Duke Nguyen on 24/05/2022.
//

import UIKit
import DesignExts

extension Keyboard {
    public struct Default {
        public static var outerSpacing: UIEdgeInsets = .init(top: 12, left: 12, bottom: 12 + 20, right: 12)
        public static var spacing: CGFloat = 6
        public static var keyboardBackground: UIColor = {
#if os(tvOS)
            return UIColor(hexString: "DFDFDF")
#else
            if #available(iOS 13.0, *) {
                return .secondarySystemBackground
            } else {
                return UIColor(hexString: "DFDFDF")
            }
#endif
        }()
        public struct Key {
            public static var background: UIColor = {
#if os(tvOS)
                return .white
#else
                if #available(iOS 13.0, *) {
                    return .systemBackground
                } else {
                    return .white
                }
#endif
            }()
            public static var foreground: UIColor = {
                if #available(iOS 13.0, *) {
                    return .label
                } else {
                    return .black
                }
            }()
            public static var font: UIFont = .systemFont(ofSize: 24)
            public static var shadow: CALayer.ShadowConfiguration = .init()
        }
    }
}
