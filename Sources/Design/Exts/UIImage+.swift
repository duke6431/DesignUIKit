//
//  UIImage+.swift
//  Design
//
//  Created by Duc IT. Nguyen Minh on 27/05/2022.
//

import UIKit

public extension UIImage {
    func tint(with color: UIColor) -> UIImage {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()

        image.draw(in: CGRect(origin: .zero, size: image.size))
        image = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return image
    }
}

@available(iOS 13.0, *)
extension UIImage {
    /// Creates a dynamic image that supports displaying a different image asset when dark mode is active.
    convenience init?(dynamicImageWithLight makeLight: @autoclosure () -> UIImage?,
                      dark makeDark: @autoclosure () -> UIImage?
    ) {
        self.init()
        guard let lightImg = makeLight(), let darkImg = makeDark() else { return nil }
        self.imageAsset?.register(lightImg, with: UITraitCollection(userInterfaceStyle: .light))
        self.imageAsset?.register(darkImg, with: UITraitCollection(userInterfaceStyle: .dark))
    }
}
