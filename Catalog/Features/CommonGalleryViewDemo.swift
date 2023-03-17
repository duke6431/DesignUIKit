//
//  CommonGalleryView.swift
//  Catalog
//
//  Created by Duc IT. Nguyen Minh on 11/03/2023.
//

import Foundation
import UIKit
import SnapKit
import DesignComponents
import DesignToolbox

class TestCollection {
    class Header: CommonCollection.ReusableView {
        lazy var titleLabel: UILabel = {
            let view = UILabel()
            view.font = FontSystem.font(with: .title3)
            return view
        }()

        override func configureViews() {
            addSubview(titleLabel)
            titleLabel.snp.makeConstraints {
                $0.top.equalToSuperview().inset(12)
                $0.leading.bottom.equalToSuperview()
                $0.trailing.lessThanOrEqualToSuperview()
            }
        }

        override func bind(_ model: CommonCollectionReusableModel) {
            guard let model = model as? Model else { return }
            titleLabel.text = model.title
        }
    }
}

extension TestCollection.Header {
    class Model: NSObject, CommonCollectionReusableModel {
        var identifier: String = UUID().uuidString
        var customConfiguration: ((DesignComponents.CommonCollection.ReusableView) -> Void)?
        var title: String

        init(
            identifier: String = UUID().uuidString,
            customConfiguration: ((DesignComponents.CommonCollection.ReusableView) -> Void)? = nil,
            title: String
        ) {
            self.identifier = identifier
            self.customConfiguration = customConfiguration
            self.title = title
        }
    }
}

extension TestCollection {
    class Cell: CommonCollection.Cell {
        static let cornerRadius: CGFloat = 12

        lazy var imageView: UIImageView = {
            let view = UIImageView()
            view.clipsToBounds = true
            view.contentMode = .scaleAspectFill
            view.layer.cornerRadius = Cell.cornerRadius * 2.0 / 3
            view.image = UIImage(named: "icon-cover")
            return view
        }()
        lazy var title: UILabel = {
            let view = UILabel()
            view.font = FontSystem.font(with: .body)
            return view
        }()

        override func configureViews() {
            contentView.clipsToBounds = true
            contentView.layer.cornerRadius = Cell.cornerRadius
            contentView.layer.addShadow(.init())

            contentView.addSubview(imageView)
            contentView.addSubview(title)
            imageView.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview().inset(8)
                $0.height.equalToSuperview().multipliedBy(0.5)
            }
            title.snp.makeConstraints {
                $0.top.equalTo(imageView.snp.bottom).offset(12)
                $0.leading.equalToSuperview().inset(12)
                $0.trailing.lessThanOrEqualToSuperview().inset(12)
            }
        }

        override func bind(_ model: CommonCollectionCellModel) {
            guard let model = model as? Model else { return }
            title.text = model.title
            contentView.backgroundColor = model.color
        }
    }
}

extension TestCollection.Cell {
    class Model: NSObject, CommonCollectionCellModel {
        var identifier: String = UUID().uuidString
        var selectable: Bool = true
        var customConfiguration: ((DesignComponents.CommonCollection.Cell) -> Void)?
        var realData: Any?

        var title: String
        var color: UIColor = .white

        init(selectable: Bool = true, customConfiguration: ((DesignComponents.CommonCollection.Cell) -> Void)? = nil, realData: Any? = nil, title: String = "Popple Launch Party 😆", color: UIColor = .white) {
            self.selectable = selectable
            self.customConfiguration = customConfiguration
            self.realData = realData
            self.title = title
            self.color = color
        }
    }
}

class CommonGalleryViewVC: UIViewController {
    lazy var collectionView: CommonCollection.View = {
        let view = CommonCollection.View(cellMapper: [
            (TestCollection.Cell.Model.self, TestCollection.Cell.self)
        ], headerMapper: [
            (TestCollection.Header.Model.self, TestCollection.Header.self)
        ])
        return view
    }()

    override func viewDidLoad() {
        navigationController?.autoDetectLeftItem()
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()

        }
        collectionView.reloadData(sections: [
            CommonCollection.Section(
                header: TestCollection.Header.Model(title: "Featured Events"),
                cells: [
                    TestCollection.Cell.Model(),
                    TestCollection.Cell.Model(),
                    TestCollection.Cell.Model(),
                    TestCollection.Cell.Model(),
                    TestCollection.Cell.Model(),
                    TestCollection.Cell.Model()
                ]
            )
            .with(dimension: .init(
                itemWHRatio: 0.81, groupWidthRatio: 0.57, groupSpacing: 16,
                sectionInset: .init(top: 12, left: 24, bottom: 5, right: 24),
                headerSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
            ))
            .with(layout: CommonCollection.Section.slidingLayout(section:)),
            CommonCollection.Section(
                header: TestCollection.Header.Model(title: "Upcoming Events"),
                cells: [
                    TestCollection.Cell.Model(title: "Study @ Cafe Landwer (FREE COFFEE!)"),
                    TestCollection.Cell.Model(),
                    TestCollection.Cell.Model(),
                    TestCollection.Cell.Model(),
                    TestCollection.Cell.Model(),
                    TestCollection.Cell.Model(),
                    TestCollection.Cell.Model()
                ]
            )
            .with(dimension: .init(
                itemWHRatio: 1.7, groupWidthRatio: 0.85, groupSpacing: 16,
                sectionInset: .init(top: 12, left: 24, bottom: 5, right: 24),
                headerSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44)))
            )
            .with(layout: CommonCollection.Section.slidingLayout(section:))
        ])
    }
}
