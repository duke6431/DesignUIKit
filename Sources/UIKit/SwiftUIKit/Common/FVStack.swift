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
        @FViewBuilder arrangedContents: () -> FBody,
        distribution: UIStackView.Distribution? = nil
    ) {
        super.init(axis: .vertical, spacing: spacing, arrangedContents: arrangedContents, distribution: distribution)
    }
}
