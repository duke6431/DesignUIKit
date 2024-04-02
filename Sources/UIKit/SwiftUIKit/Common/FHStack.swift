//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 2/20/24.
//

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif
import DesignCore

public class FHStack: FStack {
    public init(
        spacing: Double = 8,
        distribution: BStackView.Distribution? = nil,
        @FViewBuilder arrangedContents: () -> FBody
    ) {
        super.init(
            axis: .horizontal, spacing: spacing,
            distribution: distribution, arrangedContents: arrangedContents
        )
    }

    public init(
        spacing: Double = 8,
        distribution: BStackView.Distribution? = nil,
        arrangedContents: FBody
    ) {
        super.init(
            axis: .horizontal, spacing: spacing,
            distribution: distribution, arrangedContents: arrangedContents
        )
    }
}
