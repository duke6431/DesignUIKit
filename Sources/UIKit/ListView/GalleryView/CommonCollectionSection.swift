//
//  CommonCollectionSection.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2023/03/13.
//
//  This file defines the `CommonCollection.Section` class, which represents a section in a collection view.
//  It includes configuration for layout, dimension, cells, and supplementary views such as headers and footers.
//  The `LayoutDimension` struct provides fine-grained control over section, group, and item sizing and spacing,
//  as well as custom layout support.
//

import UIKit
import DesignCore

extension CommonCollection {
    /// A section in a `CommonCollection` view, representing a group of cells and optionally a header.
    ///
    /// Use this class to configure the content and layout of a section in your collection view.
    public final class Section: NSObject, @unchecked Sendable {
        /// The model representing the header supplementary view for the section.
        public var header: CommonCollectionReusableModel?
        /// The array of cell models contained in the section.
        public var cells: [CommonCollectionCellModel]
        /// A Boolean value indicating whether the section is scrollable.
        public var scrollable: Bool = true
        /// The layout dimension and configuration for the section.
        public var layoutStyle: LayoutStyle
        /// An optional closure to provide a custom layout for the section.
        public func layout() -> NSCollectionLayoutSection {
            layoutStyle.layout(section: self)
        }

        /// Creates a new section with the specified header and cells.
        /// - Parameters:
        ///   - header: The header model for the section. Defaults to `nil`.
        ///   - cells: The array of cell models for the section.
        public init(
            header: CommonCollectionReusableModel? = nil,
            cells: [CommonCollectionCellModel],
            layoutStyle: LayoutStyle
        ) {
            self.header = header
            self.cells = cells
            self.layoutStyle = layoutStyle
        }


        public enum LayoutStyle {
            case preconfigured(_ dimension: LayoutDimension)
            case customized((CommonCollection.Section) -> NSCollectionLayoutSection)
        }

        /// A struct that encapsulates layout and sizing configuration for a section.
        public struct LayoutDimension {
            /// The width-to-height ratio for each item.
            var itemSize: NSCollectionLayoutSize
            /// The spacing between items within a group.
            var itemSpacing: CGFloat = 8
            
            // Group
            var groupSize: NSCollectionLayoutSize
            /// The spacing between groups.
            var groupSpacing: CGFloat = 8
            /// The axis along which items are grouped (horizontal or vertical).
            var groupAxis: NSLayoutConstraint.Axis = .horizontal
            /// The number of items per group.
            var numberOfItemsPerGroup: Int = 1
            
            // Section
            /// The inset margins for the section.
            var sectionInset: UIEdgeInsets = .init(top: 0, left: 12, bottom: 0, right: 12)
            // Header
            /// The size of the header supplementary view, if any.
            var headerSize: NSCollectionLayoutSize?
            // Footer
            /// The size of the footer supplementary view, if any.
            var footerSize: NSCollectionLayoutSize?
            
            /// The orthogonal scrolling behavior for the section.
            var pagingBehaviour: UICollectionLayoutSectionOrthogonalScrollingBehavior = .groupPaging
            
            /// Initializes a new `LayoutDimension` with the specified properties.
            /// - Parameters:
            ///   - itemWHRatio: The width-to-height ratio for each item. Defaults to `1`.
            ///   - itemSpacing: The spacing between items within a group. Defaults to `8`.
            ///   - autoHeight: Whether the item's height is automatically determined. Defaults to `false`.
            ///   - groupAxis: The axis along which items are grouped. Defaults to `.horizontal`.
            ///   - groupWidthRatio: The width ratio of the group relative to the section's width. Defaults to `0.95`.
            ///   - groupSpacing: The spacing between groups. Defaults to `8`.
            ///   - numberItemsPerGroup: The number of items per group. Defaults to `1`.
            ///   - sectionInset: The inset margins for the section. Defaults to `UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)`.
            ///   - headerSize: The size of the header supplementary view. Defaults to `nil`.
            ///   - footerSize: The size of the footer supplementary view. Defaults to `nil`.
            ///   - pagingBehaviour: The orthogonal scrolling behavior for the section. Defaults to `.continuous`.
            public init(
                itemSize: NSCollectionLayoutSize, itemSpacing: CGFloat = 8,
                groupSize: NSCollectionLayoutSize, groupSpacing: CGFloat = 8,
                groupAxis: NSLayoutConstraint.Axis = .horizontal,
                numberItemsPerGroup: Int = 1, sectionInset: UIEdgeInsets = .init(top: 8, left: 12, bottom: 8, right: 12),
                headerSize: NSCollectionLayoutSize? = nil, footerSize: NSCollectionLayoutSize? = nil,
                pagingBehaviour: UICollectionLayoutSectionOrthogonalScrollingBehavior = .continuous
            ) {
                self.itemSize = itemSize
                self.itemSpacing = itemSpacing
                self.groupSize = groupSize
                self.groupSpacing = groupSpacing
                self.groupAxis = groupAxis
                self.numberOfItemsPerGroup = numberItemsPerGroup
                self.sectionInset = sectionInset
                self.headerSize = headerSize
                self.footerSize = footerSize
                self.pagingBehaviour = pagingBehaviour
            }
        }
    }
}

extension CommonCollection.Section.LayoutStyle {
    func layout(section: CommonCollection.Section) -> NSCollectionLayoutSection {
        switch self {
        case .preconfigured(let dimension):
            layout(section: section, dimension: dimension)
        case .customized(let configuration):
            configuration(section)
        }
    }

    /// Returns a standard "sliding" layout for the provided section, supporting horizontal or vertical scrolling.
    ///
    /// - Parameter section: The section to layout.
    /// - Returns: An `NSCollectionLayoutSection` configured for sliding presentation.
    private func layout(section: CommonCollection.Section, dimension: CommonCollection.Section.LayoutDimension) -> NSCollectionLayoutSection {
        let itemLayout = NSCollectionLayoutItem(layoutSize: dimension.itemSize)

        // Show one item plus peek
        let groupSize = dimension.groupSize
        var groupLayout: NSCollectionLayoutGroup
        switch dimension.groupAxis {
        case .vertical:
            groupLayout = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize, subitem: itemLayout, count: dimension.numberOfItemsPerGroup
            )
        default:
            groupLayout = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize, subitem: itemLayout, count: dimension.numberOfItemsPerGroup
            )
        }
        groupLayout.interItemSpacing = .fixed(dimension.itemSpacing)
        
        let sectionLayout = NSCollectionLayoutSection(group: groupLayout)
        sectionLayout.interGroupSpacing = dimension.groupSpacing
        sectionLayout.orthogonalScrollingBehavior = dimension.pagingBehaviour
        sectionLayout.contentInsets = .init(
            top: dimension.sectionInset.top,
            leading: dimension.sectionInset.left,
            bottom: dimension.sectionInset.bottom,
            trailing: dimension.sectionInset.right
        )
        var reusableSizes = [NSCollectionLayoutBoundarySupplementaryItem]()
        if section.header != nil {
            if let headerSize = dimension.headerSize {
                reusableSizes.append(
                    .init(layoutSize: headerSize,
                          elementKind: UICollectionView.ReusableKind.header.rawValue,
                          alignment: .topLeading)
                )
            }
            if let footerSize = dimension.footerSize {
                reusableSizes.append(
                    .init(layoutSize: footerSize,
                          elementKind: UICollectionView.ReusableKind.footer.rawValue,
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
