//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 12/02/2024.
//

import UIKit

public class FBase<Content: UIView>: UIView {
    public var shape: FShape?
    public var padding: UIEdgeInsets?
    
    public weak var content: Content?
    
    public override func didMoveToSuperview() {
        addSubview(rendered())
        snp.makeConstraints {
            $0.top.equalToSuperview().inset(padding?.top ?? 0).priority(.medium)
            $0.leading.equalToSuperview().inset(padding?.left ?? 0).priority(.medium)
            $0.trailing.equalToSuperview().inset(padding?.right ?? 0).priority(.medium)
            $0.bottom.equalToSuperview().inset(padding?.bottom ?? 0).priority(.medium)
        }
    }
    
    public func rendered() -> Content {
        fatalError("FBase - rendered must be overridden")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    func updateCornerRadius() {
        if let shape {
            UIView.animate(withDuration: 0.2) {
                switch shape {
                case .circle:
                    self.content?.layer.cornerRadius = min(self.bounds.width, self.bounds.height) / 2
                case .roundedRectangle(let cornerRadius, let corners):
                    self.content?.layer.masksToBounds = true
                    self.content?.layer.maskedCorners = corners.caMask
                    self.content?.layer.cornerRadius = min(cornerRadius, min(self.bounds.width, self.bounds.height)) / 2
                }
            }
        }
    }
}
