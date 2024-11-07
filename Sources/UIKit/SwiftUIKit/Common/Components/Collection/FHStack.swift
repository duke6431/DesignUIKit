//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 2/20/24.
//

import UIKit
import DesignCore

public final class FHStack: FStack {
    public init(
        spacing: Double = 8,
        distribution: UIStackView.Distribution? = nil,
        @FViewBuilder arrangedContents: () -> FBody
    ) {
        super.init(
            axis: .horizontal, spacing: spacing,
            distribution: distribution, arrangedContents: arrangedContents
        )
    }

    public init(
        spacing: Double = 8,
        distribution: UIStackView.Distribution? = nil,
        arrangedContents: FBody
    ) {
        super.init(
            axis: .horizontal, spacing: spacing,
            distribution: distribution, arrangedContents: arrangedContents
        )
    }
}
