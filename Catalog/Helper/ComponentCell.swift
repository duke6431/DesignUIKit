//
//  ComponentCell.swift
//  Catalog
//
//  Created by Duc IT. Nguyen Minh on 19/05/2022.
//

import UIKit
import SnapKit
import DesignComponents
#if canImport(Design)
import DesignToolbox
#endif

class ComponentHeaderModel: NSObject, CommonHeaderModel {
    var identifier: String = UUID().uuidString
    static var headerKind: CommonHeader.Type = ComponentHeader.self
    var customConfiguration: ((CommonHeader) -> Void)?
    var title: String

    init(identifier: String = UUID().uuidString,
         customConfigurartion: ((CommonHeader) -> Void)? = nil,
         title: String) {
        self.identifier = identifier
        self.customConfiguration = customConfigurartion
        self.title = title
    }
}

class ComponentHeader: CommonHeader {
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .bold)
        view.numberOfLines = 0
        view.textColor = .secondaryLabel
        return view
    }()

    override func configureViews() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }

    override func bind(_ model: CommonHeaderModel) {
        guard let model = model as? ComponentHeaderModel else { return }
        titleLabel.text = model.title
    }
}

class ComponentCellModel: NSObject, CommonCellModel {
    var identifier: String = UUID().uuidString
    static var cellKind: CommonCell.Type = ComponentCell.self
    var selectable: Bool = true
    var customConfiguration: ((CommonCell) -> Void)?
    var leadingActions: [UIContextualAction] = []
    var trailingActions: [UIContextualAction] = []
    var realData: Any?

    var name = ""
    var detail: String?
    var action: (() -> Void)?

    init(name: String, detail: String? = nil, action: (() -> Void)? = nil) {
        self.name = name
        self.detail = detail
        self.action = action
    }
    func isHighlighted(with keyword: String) -> Bool {
        name.lowercased().contains(keyword.lowercased())
    }
}

class ComponentCell: CommonCell {
    lazy var stack: UIStackView = {
        let view = UIStackView()
        view.spacing = 4
        view.axis = .vertical
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addArrangedSubview(title)
        view.addArrangedSubview(detail)
        return view
    }()
    lazy var title: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .label
        return view
    }()
    lazy var detail: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 13)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .secondaryLabel
        return view
    }()

    override func bind(_ model: CommonCellModel, highlight text: String) {
        guard let model = model as? ComponentCellModel else {
            return
        }
        title.attributedText = searchFor(text, in: model.name)
        if let detail = model.detail {
            self.detail.isHidden = false
            self.detail.attributedText = searchFor(text, in: detail, defaultColor: .secondaryLabel)
        } else {
            self.detail.isHidden = true
        }
    }
    override func configureViews() {
        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func searchFor(_ keyword: String, in text: String, defaultColor: UIColor = .label, highlightColor: UIColor = .systemBlue) -> NSAttributedString {
        let ranges = text.uppercased().ranges(of: keyword.uppercased())
        let attributedText = NSMutableAttributedString(string: text)
        if let range = text.ranges(of: text).first {
            attributedText.addAttribute(.foregroundColor, value: defaultColor, range: range)
        }
        ranges.forEach {
            attributedText.addAttribute(.foregroundColor, value: highlightColor, range: $0)
        }
        return attributedText
    }
}

extension String {
    func ranges(of string: String) -> [NSRange] {
        var indices = [Int]()
        var searchStartIndex = self.startIndex

        while searchStartIndex < self.endIndex,
              let range = self.range(of: string,
                                     range: searchStartIndex..<self.endIndex),
              !range.isEmpty {
            let index = distance(from: self.startIndex, to: range.lowerBound)
            indices.append(index)
            searchStartIndex = range.upperBound
        }

        return indices.map { NSRange(location: $0, length: string.count) }
    }
}
