//
//  FGrid.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2024/02/17.
//
//  A reusable grid view component built on top of `CommonCollection.View`.
//  Supports cell and header registration, theming, selection handling,
//  and model-driven layout using `FBodyComponent`-based wrappers.
//

import UIKit
import DesignCore
import DesignExts

/// A reusable and configurable grid view that supports cell and header binding
/// through reusable FBody components. Allows selection and custom configuration.
@MainActor public final class FGrid: CommonCollection.View, FConfigurable, FComponent, FAssignable {
    /// Closure for applying custom configuration after the grid is added to a superview.
    public var customConfiguration: ((FGrid) -> Void)?
    /// Callback triggered when a grid cell is selected.
    public var onSelect: ((FGridModel) -> Void)?
    /// The underlying `CommonCollection.View` instance.
    public weak var content: CommonCollection.View?
    
    /// Initializes the grid with provided reusable cell and optional header prototypes.
    /// - Parameters:
    ///   - prototypes: Cell types to register.
    ///   - headerPrototypes: Optional header types to register.
    public init(
        prototypes: [(FCellReusable & UIView).Type],
        headerPrototypes: [(FHeaderReusable & UIView).Type]? = nil
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
            guard let item = self?.sections[safe: indexPath.section]?.cells[safe: indexPath.row] as? FGridModel,
                  let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: item.model.view),
                    for: indexPath
                  ) as? FGridCell else {
                return collectionView.dequeue(UICollectionViewCell.self, indexPath: indexPath)
            }
            cell.indexPath = indexPath
            cell.bind(item)
            return cell
        }
        // swiftlint:disable:next line_length
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, _, indexPath) -> UICollectionReusableView? in
            guard let headerData = self?.sections[safe: indexPath.section]?.header as? FGridHeaderModel,
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
    
    /// Loads the default configuration for the grid.
    public func loadConfiguration() {
        configuration = .init()
        register(UICollectionViewCell.self)
    }
    
    @available(iOS, deprecated: 1.0, message: "Use reloadData(sections:) instead")
    public func reload() { }
}

public extension FGrid {
    /// Handles cell selection and invokes the onSelect callback.
    /// - Parameters:
    ///   - indexPath: The index path of the selected cell.
    ///   - data: The associated cell model.
    override func didSelectCell(at indexPath: IndexPath, with data: CommonCollectionCellModel) {
        super.didSelectCell(at: indexPath, with: data)
        guard let data = data as? FGridModel else { return }
        onSelect?(data)
    }
    
    /// Sets the selection callback for grid cells.
    /// - Parameter action: A closure receiving the selected `FGridModel`.
    /// - Returns: Self for chaining.
    @discardableResult func onSelect(_ action: @escaping (FGridModel) -> Void) -> Self {
        onSelect = action
        return self
    }
}

/// A model representing a reusable grid header view using an `FCellModeling`.
public final class FGridHeaderModel: NSObject, CommonCollectionReusableModel, Sendable {
    public let identifier: String = UUID().uuidString
    public static let headerKind: CommonCollection.ReusableView.Type = FGridHeader.self
    public var customConfiguration: (@Sendable (CommonCollection.ReusableView) -> Void)? { _customConfiguration }
    private let _customConfiguration: (@Sendable (CommonCollection.ReusableView) -> Void)?
    public let model: FHeaderModeling

    public init(model: FHeaderModeling, customConfiguration: (@Sendable (CommonCollection.ReusableView) -> Void)? = nil) {
        self.model = model
        self._customConfiguration = customConfiguration
    }
}

/// A reusable view used as a header in the `FGrid`. Wraps an FBody header component.
public class FGridHeader: CommonCollection.ReusableView {
    weak var content: (FBodyComponent & FHeaderReusable)?

    public override func bind(_ model: CommonCollectionReusableModel) {
        guard let model = model as? FGridHeaderModel else { return }
        if content == nil {
            install(view: model.model.view.empty)
            model.model.layoutConfiguration(container: self, view: content)
        }
        content?.bind(model.model)
    }
    
    /// Installs the provided view into the header and retains a reference to it.
    /// - Parameter view: The FBody header component.
    open func install<T: FBodyComponent & FHeaderReusable>(view: T) {
        backgroundColor = .clear
        addSubview(view)
        content = view
    }
}

/// A model representing a reusable grid cell backed by an `FCellModeling` component.
public final class FGridModel: NSObject, CommonCollectionCellModel, Sendable {
    public let identifier: String = UUID().uuidString
    public static let cellKind: CommonCollection.CollectionCell.Type = FGridCell.self
    public let selectable: Bool = true
    public var customConfiguration: (@Sendable (CommonCollection.CollectionCell) -> Void)? { _customConfiguration }
    public let _customConfiguration: (@Sendable (CommonCollection.CollectionCell) -> Void)?
    public let realData: Sendable?
    public let model: FCellModeling

    public init(
        model: FCellModeling,
        customConfiguration: (@Sendable (CommonCollection.CollectionCell) -> Void)? = nil,
        realData: Sendable? = nil
    ) {
        self.model = model
        self._customConfiguration = customConfiguration
        self.realData = realData
    }
}

/// A concrete grid cell that binds to an `FGridModel` and hosts an FBody view.
public class FGridCell: CommonCollection.CollectionCell {
    weak var content: (FBodyComponent & FCellReusable)?

    public override func bind(_ model: CommonCollectionCellModel) {
        guard let model = model as? FGridModel else { return }
        if content == nil {
            install(view: model.model.view.empty)
            model.model.layoutConfiguration(container: contentView, view: content)
        }
        content?.bind(model.model)
    }
    
    /// Installs and constrains the provided view into the cell's content view.
    /// - Parameter view: The FBody cell component.
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
