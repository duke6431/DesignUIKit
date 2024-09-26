//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 2/20/24.
//

import UIKit
import DesignCore

public class FVStack: FStack {
    public init(
        spacing: Double = 8,
        distribution: BStackView.Distribution? = nil,
        @FViewBuilder arrangedContents: () -> FBody
    ) {
        super.init(
            axis: .vertical, spacing: spacing,
            distribution: distribution, arrangedContents: arrangedContents
        )
    }

    public init(
        spacing: Double = 8,
        distribution: BStackView.Distribution? = nil,
        arrangedContents: FBody
    ) {
        super.init(
            axis: .vertical, spacing: spacing,
            distribution: distribution, arrangedContents: arrangedContents
        )
    }
}
