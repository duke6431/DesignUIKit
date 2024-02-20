//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 2/20/24.
//

import UIKit
import DesignCore

public class FHStack: FStack {
    public init(
        spacing: Double = 8,
        @FViewBuilder arrangedContents: () -> FBody,
        distribution: UIStackView.Distribution? = nil
    ) {
        super.init(
            axis: .horizontal, spacing: spacing,
            arrangedContents: arrangedContents, 
            distribution: distribution
        )
    }
}
