//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 26/9/24.
//

import UIKit
import DesignCore
import DesignUIKit
import RxCocoa

public extension FImage {
    convenience init(
        _ systemImagePublisher: Driver<String>
    ) {
        self.init()
        self.bind(to: systemImagePublisher) { [weak self] imageView, name in
            imageView.image = .init(systemName: name)
            if let foregroundKey = self?.foregroundKey { imageView.foreground(key: foregroundKey) }
        }
    }

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
