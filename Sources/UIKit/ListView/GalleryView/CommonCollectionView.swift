//
//  CommonCollectionView.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2023/03/11.
//
//  A reusable and configurable collection view component supporting compositional layout,
//  diffable data sources, reusable section and cell registration, and delegate-driven selection handling.
//

import DesignCore
import UIKit

/// A reusable collection view that supports dynamic layout, data mapping, and cell registration.
/// 
/// This class wraps `UICollectionView` and provides functionality for:
/// - Mapping section and cell models to reusable views
/// - Automatically generating layouts and data sources
/// - Handling selection via delegate
/// - Applying data updates using diffable snapshots
public extension CommonCollection {
    class View: UICollectionView, Loggable {
        /// Delegate responsible for handling cell selection and other collection view interactions.
        public weak var commonDelegate: CommonCollectionViewDelegate?
        
        /// List of registered cell model types used for view mapping.
        let itemMapper: [CommonCollectionCellModel.Type]
        /// Cache for the most recently used cell model type to optimize dequeuing.
        var itemCache: CommonCollectionCellModel.Type?
        /// List of registered section header model types used for view mapping.
        let sectionMapper: [CommonCollectionReusableModel.Type]?
        /// Cache for the most recently used section header model type to optimize dequeuing.
        var sectionCache: CommonCollectionReusableModel.Type?
        
        /// Current list of sections displayed by the collection view.
        var sections: [Section] = []
        /// Current diffable data source used by the collection view.
        var currentDataSource: UICollectionViewDataSource?
        
        /// Initializes the collection view with item and section mappers for reusable view registration.
        ///
        /// - Parameters:
        ///   - itemMapper: An array of `CommonCollectionCellModel` types to be registered.
        ///   - sectionMapper: An array of `CommonCollectionReusableModel` types for headers.
        public init(itemMapper: [CommonCollectionCellModel.Type], sectionMapper: [CommonCollectionReusableModel.Type]) {
            self.itemMapper = itemMapper
            self.sectionMapper = sectionMapper
            super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
            configureViews()
        }
        
        /// Unavailable. Do not use.
        @available(iOS, unavailable)
        @available(tvOS, unavailable)
        required init?(coder: NSCoder) {
            fatalError("not implemented")
        }
        
        /// Generates the diffable data source for managing cell and header reuse, binding, and configuration.
        ///
        /// - Returns: A fully configured `UICollectionViewDiffableDataSource` instance.
        func generateDataSource() -> UICollectionViewDiffableDataSource<CommonCollection.Section, String> {
            // swiftlint:disable:next line_length
            let dataSource = UICollectionViewDiffableDataSource<CommonCollection.Section, String>(collectionView: self) { [weak self] collectionView, indexPath, _ in
                guard let item = self?.sections[indexPath.section].cells[indexPath.row] else {
                    return UICollectionViewCell()
                }
                if let cachedItem = self?.itemCache?.cellKind, item.isKind(of: cachedItem) {
                    let cell = collectionView.dequeue(cachedItem, indexPath: indexPath)
                    cell.indexPath = indexPath
                    cell.bind(item)
                    return cell
                }
                guard let map = self?.itemMapper.first(where: { item.isKind(of: $0) }) else {
                    return UICollectionViewCell()
                }
                self?.itemCache = map
                let cell = collectionView.dequeue(map.cellKind, indexPath: indexPath)
                cell.indexPath = indexPath
                cell.bind(item)
                return cell
            }
            // swiftlint:disable:next line_length
            dataSource.supplementaryViewProvider = { [weak self] (collectionView, _, indexPath) -> UICollectionReusableView? in
                guard let headerData = self?.sections[indexPath.section].header else {
                    return nil
                }
                if let cachedHeader = self?.sectionCache?.headerKind, headerData.isKind(of: cachedHeader) {
                    let header = collectionView.dequeue(cachedHeader, indexPath: indexPath)
                    header.section = indexPath.section
                    header.bind(headerData)
                    headerData.customConfiguration?(header)
                    return header
                }
                guard let map = self?.sectionMapper?.first(where: { headerData.isKind(of: $0) }) else {
                    return nil
                }
                self?.sectionCache = map
                let header = collectionView.dequeue(map.headerKind, indexPath: indexPath)
                header.section = indexPath.section
                header.bind(headerData)
                headerData.customConfiguration?(header)
                return header
            }
            return dataSource
        }
        
        /// Cleans up resources when the collection view is deinitialized.
        deinit {
#if CORE_DEBUG
            logger.trace("Deinitialized \(self)")
#endif
        }
    }
}

extension CommonCollection.View {
    /// Registers cell and header view classes, sets background color and keyboard behavior.
    func configureViews() {
        translatesAutoresizingMaskIntoConstraints = false
        register(UICollectionViewCell.self)
        delegate = self
        backgroundColor = .clear
        keyboardDismissMode = .onDrag
        itemMapper.forEach { register($0.cellKind) }
        sectionMapper?.forEach { register($0.headerKind) }
    }
    
    /// Reloads the collection view with updated sections, layout, and snapshot.
    ///
    /// - Parameter sections: An array of section models to display.
    public func reloadData(sections: [CommonCollection.Section]) {
        self.sections = sections
        setCollectionViewLayout(generateLayout(), animated: false)
        let dataSource = generateDataSource()
        self.currentDataSource = dataSource
        dataSource.apply(generateSnapshot(), animatingDifferences: true)
    }
    
    /// Builds a compositional layout based on the section’s layout closure.
    ///
    /// - Returns: A new `UICollectionViewLayout` constructed from section layouts.
    func generateLayout() -> UICollectionViewLayout {
        // swiftlint:disable:next line_length
        UICollectionViewCompositionalLayout { [weak self] (section: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let section = self?.sections[section] else { return nil }
            return section.layout?(section)
        }
    }
    
    /// Constructs a snapshot from the current sections and their cell identifiers.
    ///
    /// - Returns: A snapshot representing the current collection data.
    func generateSnapshot() -> NSDiffableDataSourceSnapshot<CommonCollection.Section, String> {
        var snapshot = NSDiffableDataSourceSnapshot<CommonCollection.Section, String>()
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.cells.map { $0.identifier }, toSection: section)
        }
        return snapshot
    }
    
    /// Notifies the delegate of cell selection at the given index path.
    ///
    /// - Parameters:
    ///   - indexPath: The index path of the selected cell.
    ///   - data: The selected cell’s model.
    @objc func didSelectCell(at indexPath: IndexPath, with data: CommonCollectionCellModel) {
        commonDelegate?.didSelectCell?(at: indexPath, with: data)
    }
}

// MARK: - UICollectionViewDelegate

/// Conformance to `UICollectionViewDelegate` for handling user interactions.
extension CommonCollection.View: UICollectionViewDelegate {
    /// Called when a cell is selected in the collection view.
    ///
    /// Forwards the event to `didSelectCell(at:with:)`.
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCell(at: indexPath, with: sections[indexPath.section].cells[indexPath.row])
    }
}
