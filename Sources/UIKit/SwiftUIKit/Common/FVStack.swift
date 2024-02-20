//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 2/20/24.
//

import UIKit

public class FVStack: FStack {
    public init(
        spacing: Double = 8,
        arrangedContents: () -> [UIView],
        distribution: UIStackView.Distribution? = nil,
        customConfiguration: ((UIStackView, FStack) -> UIStackView)? = nil
    ) {
        super.init(axis: .vertical, spacing: spacing, arrangedContents: arrangedContents, distribution: distribution, customConfiguration: customConfiguration)
    }
}
