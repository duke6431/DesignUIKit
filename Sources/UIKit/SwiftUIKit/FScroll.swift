//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 12/02/2024.
//

import UIKit
import SnapKit
import DesignCore

public final class FScroll: UIView, FViewable {
    public var contentViews: [AnyViewable] = []
    public var showsVerticalScrollIndicator: Bool = false
    
    public var shape: FShape?
    public var padding: UIEdgeInsets?
    public var customConfiguration: ((UIScrollView, FScroll) -> UIScrollView)?
    
    public private(set) weak var content: UIScrollView?
    
    public init(
        contentView: AnyViewable? = nil,
        customConfiguration: ((UIScrollView, FScroll) -> UIScrollView)? = nil
    ) {
        if let contentView {
            self.contentViews = [contentView]
        } else {
            self.contentViews = []
        }
        self.customConfiguration = customConfiguration
        super.init(frame: .zero)
    }
    
    public init(
        @FBuilder<AnyViewable> contentViews: () -> [AnyViewable],
        customConfiguration: ((UIScrollView, FScroll) -> UIScrollView)? = nil
    ) {
        self.contentViews = contentViews()
        self.customConfiguration = customConfiguration
        super.init(frame: .zero)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @discardableResult
    public func rendered() -> UIScrollView {
        var view = UIScrollView()
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        var topAnchor = view.snp.top
        contentViews.enumerated().forEach { index, subview in
            let subview = subview.rendered()
            view.addSubview(subview)
            subview.snp.makeConstraints {
                $0.top.equalTo(topAnchor)
                $0.leading.trailing.centerX.equalToSuperview()
            }
            topAnchor = subview.snp.bottom
        }
        view.snp.makeConstraints {
            $0.bottom.equalTo(topAnchor)
        }
        view = customConfiguration?(view, self) ?? view
        content = view
        return view
    }
    
    public override func didMoveToSuperview() {
        addSubview(rendered())
        snp.makeConstraints {
            $0.top.equalToSuperview().inset(padding?.top ?? 0).priority(.medium)
            $0.leading.equalToSuperview().inset(padding?.left ?? 0).priority(.medium)
            $0.trailing.equalToSuperview().inset(padding?.right ?? 0).priority(.medium)
            $0.bottom.equalToSuperview().inset(padding?.bottom ?? 0).priority(.medium)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    private func updateCornerRadius() {
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
