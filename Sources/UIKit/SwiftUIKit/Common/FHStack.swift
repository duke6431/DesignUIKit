//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 2/20/24.
//

import UIKit

public class FHStack: FStack {
    public init(
        spacing: Double = 8,
        arrangedContents: () -> [UIView],
        distribution: UIStackView.Distribution? = nil,
        customConfiguration: ((UIStackView, FStack) -> UIStackView)? = nil
    ) {
        super.init(
            axis: .horizontal, spacing: spacing,
            arrangedContents: arrangedContents, 
            distribution: distribution,
            customConfiguration: customConfiguration
        )
    }
}
