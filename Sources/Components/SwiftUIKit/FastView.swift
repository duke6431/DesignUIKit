//
//  FastView.swift
//  DesignComponents
//
//  Created by Duc IT. Nguyen Minh on 12/09/2023.
//

import UIKit
import DesignToolbox
import DesignCore

public class QSpacer: UIView, ViewBuildable {
    public var width: Double
    public var height: Double

    public init(width: Double? = nil, height: Double? = nil) {
        self.width = width ?? 0
        self.height = height ?? 0
        super.init(
            frame: .init(
                origin: .zero,
                size: .init(
                    width: self.width,
                    height: self.height
                )
            )
        )
    }

    func configureViews() {
        NSLayoutConstraint.activate {
            heightAnchor.constraint(equalToConstant: height)
                .with(\.priority, setTo: .defaultLow)
            widthAnchor.constraint(equalToConstant: width)
                .with(\.priority, setTo: .defaultLow)
        }
    }

    @available(iOS, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}

public struct QEmpty: ViewBuildableConvertible {
    public func view() -> [ViewBuildable] { [] }
}
