//
//  CommonCollectionSection.swift
//  DesignComponents
//
//  Created by Duc IT. Nguyen Minh on 13/03/2023.
//

import UIKit
import DesignCore

public typealias BCollectionViewCell = UICollectionViewCell
public typealias BCollectionView = UICollectionView
public typealias BCollectionLayoutSectionOrthogonalScrollingBehavior = UICollectionLayoutSectionOrthogonalScrollingBehavior

@available(iOS 13.0, *)
extension CommonCollection {
    public final class Section: NSObject, @unchecked Sendable {
        public var header: CommonCollectionReusableModel?
        public var cells: [CommonCollectionCellModel]
        public var scrollable: Bool = true
        public var dimension: LayoutDimension = .init()
        public var layout: ((Section) -> NSCollectionLayoutSection)?

        public init(header: CommonCollectionReusableModel? = nil,
                    cells: [CommonCollectionCellModel]) {
            self.header = header
            self.cells = cells
        }

        public func with(layout: @escaping (Section) -> NSCollectionLayoutSection) -> Self {
            self.layout = layout
            return self
        }

        public func with(dimension: LayoutDimension) -> Self {
            self.dimension = dimension
            return self
        }

        public struct LayoutDimension {
            var autoHeight: Bool = false
            var itemWHRatio: CGFloat = 1
            var itemSpacing: CGFloat = 8

            // Group
            var groupAxis: BAxis = .horizontal
            var groupWidthRatio: CGFloat = 0.95
            var groupSpacing: CGFloat = 8
            var numberOfItemsPerGroup: Int = 1

            // Section
            var sectionInset: BEdgeInsets = .init(top: 8, left: 12, bottom: 8, right: 12)
            // Header
            var headerSize: NSCollectionLayoutSize?
            // Footer
            var footerSize: NSCollectionLayoutSize?

            var pagingBehaviour: BCollectionLayoutSectionOrthogonalScrollingBehavior = .groupPaging

            public init(
                itemWHRatio: CGFloat = 1, itemSpacing: CGFloat = 8, autoHeight: Bool = false,
                groupAxis: BAxis = .horizontal,
                groupWidthRatio: CGFloat = 0.95, groupSpacing: CGFloat = 8, numberItemsPerGroup: Int = 1,
                sectionInset: BEdgeInsets = .init(top: 8, left: 12, bottom: 8, right: 12),
                headerSize: NSCollectionLayoutSize? = nil, footerSize: NSCollectionLayoutSize? = nil,
                pagingBehaviour: BCollectionLayoutSectionOrthogonalScrollingBehavior = .continuous
            ) {
                self.itemWHRatio = itemWHRatio
                self.itemSpacing = itemSpacing
                self.autoHeight = autoHeight
                self.groupAxis = groupAxis
                self.groupWidthRatio = groupWidthRatio
                self.groupSpacing = groupSpacing
                self.numberOfItemsPerGroup = numberItemsPerGroup
                self.sectionInset = sectionInset
                self.headerSize = headerSize
                self.footerSize = footerSize
                self.pagingBehaviour = pagingBehaviour
            }
        }
    }
}

@available(iOS 13.0, *)
extension CommonCollection.Section {
    public static func slidingLayout(section: CommonCollection.Section) -> NSCollectionLayoutSection {
        let itemLayout = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: section.dimension.autoHeight ? .estimated(44) : .fractionalWidth(1 / section.dimension.itemWHRatio)
            )
        )
        
        // Show one item plus peek
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(section.dimension.groupWidthRatio),
            heightDimension: section.dimension.autoHeight 
            ? .estimated(CGFloat(44 * section.dimension.numberOfItemsPerGroup) + CGFloat(section.dimension.numberOfItemsPerGroup) * section.dimension.itemSpacing)
            : .fractionalWidth(section.dimension.groupWidthRatio / section.dimension.itemWHRatio / CGFloat(section.dimension.numberOfItemsPerGroup) * ceil(CGFloat(section.cells.count) / CGFloat(section.dimension.numberOfItemsPerGroup)))
        )
        var groupLayout: NSCollectionLayoutGroup
        switch section.dimension.groupAxis {
        case .vertical:
            groupLayout = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize, subitem: itemLayout, count: section.dimension.numberOfItemsPerGroup
            )
        default:
            groupLayout = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize, subitem: itemLayout, count: section.dimension.numberOfItemsPerGroup
            )
        }
        groupLayout.interItemSpacing = .fixed(section.dimension.itemSpacing)

        let sectionLayout = NSCollectionLayoutSection(group: groupLayout)
        sectionLayout.interGroupSpacing = section.dimension.groupSpacing
        sectionLayout.orthogonalScrollingBehavior = section.dimension.pagingBehaviour
        sectionLayout.contentInsets = .init(
            top: section.dimension.sectionInset.top,
            leading: section.dimension.sectionInset.left,
            bottom: section.dimension.sectionInset.bottom,
            trailing: section.dimension.sectionInset.right
        )
        var reusableSizes = [NSCollectionLayoutBoundarySupplementaryItem]()
        if section.header != nil {
            if let headerSize = section.dimension.headerSize {
                reusableSizes.append(
                    .init(layoutSize: headerSize,
                          elementKind: BCollectionView.ReusableKind.header.rawValue,
                          alignment: .topLeading)
                )
            }
            if let footerSize = section.dimension.footerSize {
                reusableSizes.append(
                    .init(layoutSize: footerSize,
                          elementKind: BCollectionView.ReusableKind.footer.rawValue,
                          alignment: .bottomLeading)
                )
            }
            if !reusableSizes.isEmpty {
                sectionLayout.boundarySupplementaryItems = reusableSizes
            }
        }
        return sectionLayout
    }
}
