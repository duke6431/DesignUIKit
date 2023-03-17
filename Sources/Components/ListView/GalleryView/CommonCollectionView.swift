//
//  CommonCollectionView.swift
//  DesignComponents
//
//  Created by Duc IT. Nguyen Minh on 11/03/2023.
//

import DesignCore
import UIKit
#if canImport(DesignToolbox)
import DesignToolbox
#endif

public extension CommonCollection {
    class View: UICollectionView {
        public weak var commonDelegate: CommonSlidingViewDelegate?

        private let cellMapper: [CommonCollectionConfigPair]
        private var cellCache: CommonCollectionConfigPair?
        private let headerMapper: [CommonCollectionHeaderConfigPair]?
        private var headerCache: CommonCollectionHeaderConfigPair?
        private var sections: [Section] = []
        private var currentDataSource: UICollectionViewDataSource?

        public init(cellMapper: [CommonCollectionConfigPair], headerMapper: [CommonCollectionHeaderConfigPair]? = nil) {
            self.headerMapper = headerMapper
            self.cellMapper = cellMapper
            super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
            configureViews()
        }

        @available(iOS, unavailable)
        required init?(coder: NSCoder) {
            fatalError("not implemented")
        }
    }
}

extension CommonCollection.View {
    func configureViews() {
        translatesAutoresizingMaskIntoConstraints = false
        register(UICollectionViewCell.self)
        delegate = self
        backgroundColor = .clear
        keyboardDismissMode = .onDrag
        cellMapper.forEach { register($0.cell) }
        headerMapper?.forEach { register($0.header) }
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

    func generateDataSource() -> UICollectionViewDiffableDataSource<CommonCollection.Section, String> {
        // swiftlint:disable:next line_length
        let dataSource = UICollectionViewDiffableDataSource<CommonCollection.Section, String>(collectionView: self) { [weak self] collectionView, indexPath, _ in
            guard let item = self?.sections[indexPath.section].cells[indexPath.row] else {
                return UICollectionViewCell()
            }
            if let cachedCell = self?.cellCache, item.isKind(of: cachedCell.model) {
                let cell = collectionView.dequeue(cachedCell.cell, indexPath: indexPath)
                cell.indexPath = indexPath
                cell.bind(item)
                return cell
            }
            guard let map = self?.cellMapper.first(where: { item.isKind(of: $0.model) }) else {
                return UICollectionViewCell()
            }
            self?.cellCache = map
            let cell = collectionView.dequeue(map.cell, indexPath: indexPath)
            cell.indexPath = indexPath
            cell.bind(item)
            return cell
        }
        // swiftlint:disable:next line_length
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, _, indexPath) -> UICollectionReusableView? in
            guard let headerData = self?.sections[indexPath.section].header else {
                return nil
            }
            if let cachedHeader = self?.headerCache, headerData.isKind(of: cachedHeader.model) {
                let header = collectionView.dequeue(cachedHeader.header, indexPath: indexPath)
                header.section = indexPath.section
                header.bind(headerData)
                headerData.customConfiguration?(header)
                return header
            }
            guard let map = self?.headerMapper?.first(where: { headerData.isKind(of: $0.model) }) else {
                return nil
            }
            self?.headerCache = map
            let header = collectionView.dequeue(map.header, indexPath: indexPath)
            header.section = indexPath.section
            header.bind(headerData)
            headerData.customConfiguration?(header)
            return header
        }
        return dataSource
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

extension CommonCollection.View: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCell(at: indexPath, with: sections[indexPath.section].cells[indexPath.row])
    }
}
