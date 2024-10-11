//
//  CommonCollectionView.swift
//  DesignComponents
//
//  Created by Duc IT. Nguyen Minh on 11/03/2023.
//

import DesignCore
import UIKit

@available(iOS 13.0, *)
public extension CommonCollection {
    class View: UICollectionView {
        public weak var commonDelegate: CommonCollectionViewDelegate?

        let itemMapper: [CommonCollectionCellModel.Type]
        var itemCache: CommonCollectionCellModel.Type?
        let sectionMapper: [CommonCollectionReusableModel.Type]?
        var sectionCache: CommonCollectionReusableModel.Type?

        var sections: [Section] = []
        var currentDataSource: UICollectionViewDataSource?

        public init(itemMapper: [CommonCollectionCellModel.Type], sectionMapper: [CommonCollectionReusableModel.Type]) {
            self.itemMapper = itemMapper
            self.sectionMapper = sectionMapper
            super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
            configureViews()
        }

        @available(iOS, unavailable)
        @available(tvOS, unavailable)
        required init?(coder: NSCoder) {
            fatalError("not implemented")
        }
        
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
    }
}

@available(iOS 13.0, *)
extension CommonCollection.View {
    func configureViews() {
        translatesAutoresizingMaskIntoConstraints = false
        register(UICollectionViewCell.self)
        delegate = self
        backgroundColor = .clear
        keyboardDismissMode = .onDrag
        itemMapper.forEach { register($0.cellKind) }
        sectionMapper?.forEach { register($0.headerKind) }
    }

    public func reloadData(sections: [CommonCollection.Section]) {
        self.sections = sections
        setCollectionViewLayout(generateLayout(), animated: false)
        let dataSource = generateDataSource()
        self.currentDataSource = dataSource
        dataSource.apply(generateSnapshot(), animatingDifferences: true)
    }

    func generateLayout() -> UICollectionViewLayout {
        // swiftlint:disable:next line_length
        UICollectionViewCompositionalLayout { [weak self] (section: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let section = self?.sections[section] else { return nil }
            return section.layout?(section)
        }
    }

    func generateSnapshot() -> NSDiffableDataSourceSnapshot<CommonCollection.Section, String> {
        var snapshot = NSDiffableDataSourceSnapshot<CommonCollection.Section, String>()
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.cells.map { $0.identifier }, toSection: section)
        }
        return snapshot
    }

    @objc func didSelectCell(at indexPath: IndexPath, with data: CommonCollectionCellModel) {
        commonDelegate?.didSelectCell?(at: indexPath, with: data)
    }
}

@available(iOS 13.0, *)
extension CommonCollection.View: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCell(at: indexPath, with: sections[indexPath.section].cells[indexPath.row])
    }
}
