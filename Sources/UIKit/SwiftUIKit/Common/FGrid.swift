//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 17/02/2024.
//

import UIKit
import Combine
import SnapKit
import DesignCore
import DesignExts

public class FGrid: CommonCollection.View, FConfigurable, FComponent {
    public var customConfiguration: ((FGrid) -> Void)?
    public var onSelect: ((FGridModel) -> Void)?
    public weak var content: CommonCollection.View?
    public var cancellables = Set<AnyCancellable>()
    
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
        loadConfiguration()
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
    
    open func loadConfiguration() {
        configuration = .init()
    }
}

public extension FGrid {
    override func didSelectCell(at indexPath: IndexPath, with data: CommonCollectionCellModel) {
        super.didSelectCell(at: indexPath, with: data)
        guard let data = data as? FGridModel else { return }
        onSelect?(data)
    }
    
    @discardableResult func onSelect(_ action: @escaping (FGridModel) -> Void) -> Self {
        onSelect = action
        return self
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
    weak var content: (FBodyComponent & FCellReusable)?
    
    public override func bind(_ model: CommonCollectionReusableModel) {
        guard let model = model as? FGridHeaderModel else { return }
        if content == nil {
            install(view: model.model.view.empty)
            model.model.layoutConfiguration(container: self, view: content)
        }
        content?.bind(model.model)
    }
    
    open func install<T: FBodyComponent & FCellReusable>(view: T) {
        backgroundColor = .clear
        addSubview(view)
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
    weak var content: (FBodyComponent & FCellReusable)?
    
    public override func bind(_ model: CommonCollectionCellModel) {
        guard let model = model as? FGridModel else { return }
        if content == nil {
            install(view: model.model.view.empty)
            model.model.layoutConfiguration(container: contentView, view: content)
        }
        content?.bind(model.model)
    }
    
    open func install<T: FBodyComponent & FCellReusable>(view: T) {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        view.attachToParent(false)
        contentView.addSubview(view)
        view.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        content = view
    }
}
