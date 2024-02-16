//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 16/02/2024.
//

import UIKit
import DesignCore

public class DimmingButton: UIButton {
    public var onHighlight: ((Bool) -> Void)?
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addAction(for: .touchDown) { [weak self] in
            self?.should(highlight: true)
            self?.onHighlight?(true)
        }
        addAction(for: [.touchUpInside, .touchUpOutside]) { [weak self] in
            self?.should(highlight: false)
            self?.onHighlight?(false)
        }
    }
    
    func should(highlight highlighted: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.alpha = highlighted ? 0.4 : 1
        }
    }
}
