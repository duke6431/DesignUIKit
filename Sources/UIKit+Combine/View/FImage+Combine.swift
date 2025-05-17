//
//  File.swift
//  ComponentSystem
//
//  Created by Duke Nguyen on 26/9/24.
//

import UIKit
import DesignCore
import DesignUIKit

extension FImage {
    public convenience init(
        _ systemImagePublisher: FBinder<String>
    ) {
        self.init()
        self.bind(to: systemImagePublisher) { [weak self] imageView, name in
            imageView.image = .init(systemName: name)
            if let foregroundKey = self?.foregroundKey { imageView.foreground(key: foregroundKey) }
        }
    }
    
    public convenience init(
        _ imagePublisher: FBinder<UIImage>
    ) {
        self.init()
        self.bind(to: imagePublisher) { [weak self] imageView, image in
            imageView.image = image
            if let foregroundKey = self?.foregroundKey { imageView.foreground(key: foregroundKey) }
        }
    }
}
