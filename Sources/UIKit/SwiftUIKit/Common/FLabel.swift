//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore
import SnapKit

public final class FLabel: BaseLabel, FConfigurable, FComponent, FStylable, FContentAvailable {
    public var customConfiguration: ((FLabel) -> Void)?
    
    public init(
        _ text: String
    ) {
        super.init(frame: .zero)
        self.text = text
    }
    
    public init(_ attributedText: NSAttributedString) {
        super.init(frame: .zero)
        self.attributedText = attributedText
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configuration?.didMoveToSuperview(superview, with: self)
        customConfiguration?(self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
    }

    public func textAlignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }

    public func lineLimit(_ lineLimit: Int = 1) -> Self {
        self.numberOfLines = lineLimit
        return self
    }
}
