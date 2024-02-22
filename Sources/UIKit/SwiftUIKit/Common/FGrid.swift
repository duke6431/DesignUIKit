//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 17/02/2024.
//

import UIKit
import DesignCore
import DesignExts

public class FGrid: CommonCollection.View, FComponent {
    public var shape: FShape?
    public var opacity: CGFloat = 1
    public var shadow: CALayer.ShadowConfiguration?
    public var contentBackgroundColor: UIColor = .clear
    
    public var width: CGFloat?
    public var height: CGFloat?
    public var ratio: CGFloat?
    public var containerPadding: UIEdgeInsets?
    public var contentInsets: UIEdgeInsets?
    public var shouldConstraintWithParent: Bool = true
    public var customConfiguration: ((CommonCollection.View, FGrid) -> CommonCollection.View)?
    
    public weak var content: CommonCollection.View?
    
    public init(
        prototypes: [(FCellReusable & UIView).Type],
        headerPrototypes: [(FCellReusable & UIView).Type]? = nil
    ) {
        super.init(itemMapper: [], sectionMapper: [])
        prototypes.forEach {
            register(FGridCell.self, forCellWithReuseIdentifier: String(describing: $0))
        }
        headerPrototypes?.forEach {
            register(FGridHeader.self, forSupplementaryViewOfKind: ReusableKind.header.rawValue, withReuseIdentifier: String(describing: $0))
        }
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        alpha = opacity
        if shouldConstraintWithParent, superview != nil {
            snp.makeConstraints {
                $0.top.equalToSuperview().inset(containerPadding?.top ?? 0)
                $0.leading.equalToSuperview().inset(containerPadding?.left ?? 0)
                $0.trailing.equalToSuperview().inset(containerPadding?.right ?? 0)
                $0.bottom.equalToSuperview().inset(containerPadding?.bottom ?? 0)
                if let ratio { $0.width.equalTo(snp.height).multipliedBy(ratio) }
                if let width { $0.width.equalTo(width) }
                if let height { $0.height.equalTo(height) }
            }
        }
        _ = customConfiguration?(self, self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateLayers()
    }
    
    func updateLayers() {
        if let shape {
            clipsToBounds = true
            UIView.animate(withDuration: 0.2) {
                switch shape {
                case .circle:
                    self.layer.cornerRadius = min(self.bounds.width, self.bounds.height) / 2
                case .roundedRectangle(let cornerRadius, let corners):
                    self.layer.maskedCorners = corners.caMask
                    self.layer.cornerRadius = min(cornerRadius, min(self.bounds.width, self.bounds.height) / 2)
                }
            }
        }
        if let shadow {
            UIView.animate(withDuration: 0.2) {
                self.layer.add(
                    shadow: shadow.updated(
                        \.path, with: UIBezierPath(rect: self.bounds).cgPath
                    )
                )
            }
        }
    }
    
    public func frame(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        self.width = width
        self.height = height
        return self
    }
    
    @available(iOS, deprecated, message: "This function of FList and FGrid should not be called")
    public func rendered() -> CommonCollection.View {
        fatalError("Never call this function of FList!")
    }
    
    override func generateDataSource() -> UICollectionViewDiffableDataSource<CommonCollection.Section, String> {
        // swiftlint:disable:next line_length
        let dataSource = UICollectionViewDiffableDataSource<CommonCollection.Section, String>(
            collectionView: self
        ) { [weak self] collectionView, indexPath, _ in
            guard let item = self?.sections[indexPath.section].cells[indexPath.row] as? FGridModel,
                  let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: item.model.view),
                    for: indexPath
                  ) as? FGridCell else {
                return UICollectionViewCell()
            }
            cell.indexPath = indexPath
            cell.bind(item)
            return cell
        }
        // swiftlint:disable:next line_length
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, _, indexPath) -> UICollectionReusableView? in
            guard let headerData = self?.sections[indexPath.section].header as? FGridHeaderModel,
                  let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: ReusableKind.header.rawValue,
                    withReuseIdentifier: String(describing: headerData.model.view),
                    for: indexPath
                  ) as? FGridHeader else {
                return nil
            }
            header.section = indexPath.section
            header.bind(headerData)
            headerData.customConfiguration?(header)
            return header
        }
        return dataSource
    }
}

public class FGridHeaderModel: NSObject, CommonCollectionReusableModel {
    public var identifier: String = UUID().uuidString
    public static var headerKind: CommonCollection.ReusableView.Type = FGridHeader.self
    public var customConfiguration: ((CommonCollection.ReusableView) -> Void)?
    public var model: FCellModeling
    
    public init(model: FCellModeling) {
        self.model = model
    }
}

public class FGridHeader: CommonCollection.ReusableView {
    weak var content: FCellReusable?
    
    public override func bind(_ model: CommonCollectionReusableModel) {
        guard let model = model as? FGridHeaderModel else { return }
        if content == nil { install(view: model.model.view.empty) }
        content?.bind(model.model)
    }
    
    open func install<T: FCellReusable & UIView>(view: T) {
        backgroundColor = .clear
        addSubview(view)
        view.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        content = view
    }
}

public class FGridModel: NSObject, CommonCollectionCellModel {
    public var identifier: String = UUID().uuidString
    public static var cellKind: CommonCollection.Cell.Type = FGridCell.self
    public var selectable: Bool = true
    public var customConfiguration: ((CommonCollection.Cell) -> Void)?
    public var realData: Any?
    public var model: FCellModeling
    
    public init(
        model: FCellModeling,
        realData: Any? = nil
    ) {
        self.model = model
        self.realData = realData
    }
}

public class FGridCell: CommonCollection.Cell {
    weak var content: FCellReusable?
    
    public override func bind(_ model: CommonCollectionCellModel) {
        guard let model = model as? FGridModel else { return }
        if content == nil { install(view: model.model.view.empty) }
        content?.bind(model.model)
    }
    
    open func install<T: FCellReusable & UIView>(view: T) {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.addSubview(view)
        view.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        content = view
    }
}
