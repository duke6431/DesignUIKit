//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 20/10/24.
//

import UIKit

public final class FContainer<View: UIView>: FView {
    var content: View

    public init(content: View) {
        self.content = content
        super.init(frame: .zero)
    }

    public override func configureViews() {
        addSubview(content)
        content.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }

    public func configure(_ contentConfiguration: (View) -> Void) -> Self {
        contentConfiguration(content)
        return self
    }
}
