//
//  FastView+Scroll.swift
//  DesignKit
//
//  Created by Duc IT. Nguyen Minh on 12/09/2023.
//

import UIKit
import DesignCore

public class QScroll: UIScrollView, ViewBuildable {
    public var axis: NSLayoutConstraint.Axis
    public var content: () -> [ViewBuildable]
    public var customConfiguration: ((UIScrollView, [ViewBuildable]) -> Void)?

    public init(axis: NSLayoutConstraint.Axis = .vertical,
                @ViewBuilder _ content: @escaping () -> [ViewBuildable],
                customConfiguration: ((UIScrollView, [ViewBuildable]) -> Void)? = nil) {
        self.axis = axis
        self.content = content
        self.customConfiguration = customConfiguration
        super.init(frame: .zero)
        configureViews()
    }

    @available(iOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Unavailable")
    }

    public func configureViews() {
        translatesAutoresizingMaskIntoConstraints = false
        let content = QStack(axis: axis, content)
        addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate {
            content.topAnchor.constraint(equalTo: topAnchor)
            content.bottomAnchor.constraint(equalTo: bottomAnchor)
            content.leadingAnchor.constraint(equalTo: leadingAnchor)
            content.trailingAnchor.constraint(equalTo: trailingAnchor)
        }
        NSLayoutConstraint.activate {
            switch axis {
            case .horizontal:
                content.centerYAnchor.constraint(equalTo: centerYAnchor)
            case .vertical:
                content.centerXAnchor.constraint(equalTo: centerXAnchor)
            @unknown default:
                content.centerXAnchor.constraint(equalTo: centerXAnchor)

            }
        }
        customConfiguration?(self, self.content())
    }
}

public class QList: CommonTableView, ViewBuildable {
    init(@BuilderComponent<CommonTableSection> sections: () -> [CommonTableSection], style: UITableView.Style = .plain) {
        let sections = sections()
        super.init(map: sections.flatMap(\.items).map { type(of: $0) },
                   headerMap: sections.compactMap(\.header).map { type(of: $0) })
        reloadData(sections: sections)
    }
}
