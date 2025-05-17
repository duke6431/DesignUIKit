//
//  FImage+Rx.swift
//  DesignRxUIKit
//
//  Created by Duke Nguyen on 2024/09/26.
//
//  Adds RxSwift-based convenience initializers for binding image updates
//  to `FImage` instances using reactive `Driver` streams.
//

import UIKit
import DesignCore
import DesignUIKit
import RxCocoa

public extension FImage {
    /// Initializes an `FImage` view that updates its image based on a system image name stream.
    /// - Parameter systemImagePublisher: A `Driver` that emits `String` values representing SF Symbol names.
    convenience init(
        _ systemImagePublisher: Driver<String>
    ) {
        self.init()
        self.bind(to: systemImagePublisher) { [weak self] imageView, name in
            imageView.image = .init(systemName: name)
            if let foregroundKey = self?.foregroundKey { imageView.foreground(key: foregroundKey) }
        }
    }
    
    /// Initializes an `FImage` view that updates its image reactively using a stream of `UIImage`.
    /// - Parameter imagePublisher: A `Driver` that emits `UIImage` instances for binding.
    convenience init(
        _ imagePublisher: Driver<UIImage>
    ) {
        self.init()
        self.bind(to: imagePublisher) { [weak self] imageView, image in
            imageView.image = image
            if let foregroundKey = self?.foregroundKey { imageView.foreground(key: foregroundKey) }
        }
    }
}
