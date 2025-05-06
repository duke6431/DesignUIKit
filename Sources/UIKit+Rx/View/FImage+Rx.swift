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
        self.bind(to: systemImagePublisher) {
            $0.image = .init(systemName: $1)
            $0.rebindImageColor()
        }
    }

    convenience init(
        _ imagePublisher: Driver<UIImage>
    ) {
        self.init()
        self.bind(to: imagePublisher) {
            $0.image = $1
            $0.rebindImageColor()
        }
    }
    
    private func rebindImageColor() {
        if let currentForegroundColor {
            image = image?.withTintColor(currentForegroundColor, renderingMode: .alwaysOriginal)
        }
        if let foregroundKey { foreground(key: foregroundKey) }
    }
}
