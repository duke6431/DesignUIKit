//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 12/02/2024.
//

import UIKit
import SnapKit

public class FBase<Content: UIView>: UIView {
    public var shape: FShape?
    public var padding: UIEdgeInsets?
    public var contentInsets: UIEdgeInsets?
    public var width: CGFloat?
    public var height: CGFloat?
    
    public weak var content: Content?
    
    public override func didMoveToSuperview() {
        addSubview(rendered())
        snp.makeConstraints {
            $0.top.equalToSuperview().inset(padding?.top ?? 0)//.priority(.high.advanced(by: 100))
            $0.leading.equalToSuperview().inset(padding?.left ?? 0)//.priority(.high.advanced(by: 100))
            $0.trailing.equalToSuperview().inset(padding?.right ?? 0)//.priority(.high.advanced(by: 100))
            $0.bottom.equalToSuperview().inset(padding?.bottom ?? 0)//.priority(.high.advanced(by: 100))
        }
        content?.snp.makeConstraints {
            $0.top.equalToSuperview().inset(contentInsets?.top ?? 0)//.priority(.high.advanced(by: 100))
            $0.leading.equalToSuperview().inset(contentInsets?.left ?? 0)//.priority(.high.advanced(by: 100))
            $0.trailing.equalToSuperview().inset(contentInsets?.right ?? 0)//.priority(.high.advanced(by: 100))
            $0.bottom.equalToSuperview().inset(contentInsets?.bottom ?? 0)//.priority(.high.advanced(by: 100))
            if let width { $0.width.equalTo(width) }
            if let height { $0.height.equalTo(height) }
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
    
    public func frame(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        self.width = width
        self.height = height
        return self
    }
}
