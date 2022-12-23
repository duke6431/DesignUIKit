//
//  ComponentSystem.swift
//  
//
//  Created by Duc Minh Nguyen on 5/17/22.
//

import UIKit
// import Nuke
//
// public protocol ImageLoader {
//    static func loadImage(url: URL, _ completion: (UIImage?) -> Void)
// }

public struct ComponentSystem {
    public struct Default {
        public struct Image {
            public static var placeholder: UIImage?
            public static var failure: UIImage?
//            public static var fetchingOption = ImageLoadingOptions(
//                placeholder: placeholder,
//                transition: .fadeIn(duration: 0.2),
//                failureImage: failure,
//                failureImageTransition: .fadeIn(duration: 0.2),
//                contentModes: .init(success: .scaleAspectFit, failure: .scaleAspectFit, placeholder: .scaleAspectFit),
//                tintColors: nil)
//            public static var processor: [ImageProcessors] =
        }
    }
}

// extension ComponentSystem: ImageLoader {
//    public static func loadImage(url: URL, _ completion: (UIImage?) -> Void) {
//    }
// }
