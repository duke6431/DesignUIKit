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
    @MainActor
    public final class Section: NSObject {
        /// The model representing the header supplementary view for the section.
        public let header: CommonCollectionReusableModel?
        /// The array of cell models contained in the section.
        public let cells: [CommonCollectionCellModel]
        /// A Boolean value indicating whether the section is scrollable.
        public var scrollable: Bool = true
        /// The layout dimension and configuration for the section.
        public var dimension: LayoutDimension = .init()
        /// An optional closure to provide a custom layout for the section.
        public var layout: (@MainActor (Section) -> NSCollectionLayoutSection)? = nil
        
        /// Creates a new section with the specified header and cells.
        /// - Parameters:
        ///   - header: The header model for the section. Defaults to `nil`.
        ///   - cells: The array of cell models for the section.
        public init(header: CommonCollectionReusableModel? = nil,
                    cells: [CommonCollectionCellModel]) {
            self.header = header
            self.cells = cells
            super.init()
        }
        
        /// Returns a new section with the specified layout closure.
        /// - Parameter layout: A closure that returns the layout for the section.
        /// - Returns: The modified section instance.
        public func with(layout: @escaping (@MainActor (Section) -> NSCollectionLayoutSection)) -> Self {
            self.layout = layout
            return self
        }
        
        /// Returns a new section with the specified layout dimension.
        /// - Parameter dimension: The layout dimension to apply to the section.
        /// - Returns: The modified section instance.
        public func with(dimension: LayoutDimension) -> Self {
            self.dimension = dimension
            return self
        }
        
        /// A struct that encapsulates layout and sizing configuration for a section.
        public struct LayoutDimension: Sendable {
            /// If `true`, the item's height is automatically determined (estimated).
            var autoHeight: Bool = false
            /// The width-to-height ratio for each item.
            var itemWHRatio: CGFloat = 1
            /// The spacing between items within a group.
            var itemSpacing: CGFloat = 8
            
            // Group
            /// The axis along which items are grouped (horizontal or vertical).
            var groupAxis: NSLayoutConstraint.Axis = .horizontal
            /// The width ratio of the group relative to the section's width.
            var groupWidthRatio: CGFloat = 0.95
            /// The spacing between groups.
            var groupSpacing: CGFloat = 8
            /// The number of items per group.
            var numberOfItemsPerGroup: Int = 1
            
            // Section
            /// The inset margins for the section.
            var sectionInset: UIEdgeInsets = .init(top: 8, left: 12, bottom: 8, right: 12)
            // Header
            /// The size of the header supplementary view, if any.
            var headerSize: NSCollectionLayoutSize?
            // Footer
            /// The size of the footer supplementary view, if any.
            var footerSize: NSCollectionLayoutSize?
            
            /// The orthogonal scrolling behavior for the section.
            var pagingBehaviour: UICollectionLayoutSectionOrthogonalScrollingBehavior = .groupPaging
            
            /// An optional closure to provide a completely custom layout for the section.
            var customLayout: (@MainActor (CommonCollection.Section) -> NSCollectionLayoutSection)?
            
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
                itemWHRatio: CGFloat = 1, itemSpacing: CGFloat = 8, autoHeight: Bool = false,
                groupAxis: NSLayoutConstraint.Axis = .horizontal,
                groupWidthRatio: CGFloat = 0.95, groupSpacing: CGFloat = 8, numberItemsPerGroup: Int = 1,
                sectionInset: UIEdgeInsets = .init(top: 8, left: 12, bottom: 8, right: 12),
                headerSize: NSCollectionLayoutSize? = nil, footerSize: NSCollectionLayoutSize? = nil,
                pagingBehaviour: UICollectionLayoutSectionOrthogonalScrollingBehavior = .continuous
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
            
            /// Initializes a new `LayoutDimension` using a custom layout closure.
            /// - Parameter customLayout: A closure that returns a custom layout for the section.
            public init(customLayout: @escaping (@MainActor (CommonCollection.Section) -> NSCollectionLayoutSection)) {
                self.customLayout = customLayout
            }
        }
    }
}

extension CommonCollection.Section {
    @MainActor static func resolvedSlidingItemWHRatio(for section: CommonCollection.Section) -> CGFloat {
        let ratio = section.dimension.itemWHRatio
        return ratio.isFinite && ratio > 0 ? ratio : 1
    }
    
    @MainActor static func resolvedSlidingGroupWidthRatio(for section: CommonCollection.Section) -> CGFloat {
        let ratio = section.dimension.groupWidthRatio
        return ratio.isFinite && ratio > 0 ? ratio : 1
    }
    
    @MainActor static func slidingGroupHeightRatio(for section: CommonCollection.Section) -> CGFloat {
        resolvedSlidingGroupWidthRatio(for: section) / resolvedSlidingItemWHRatio(for: section)
    }
    
    /// Returns a standard "sliding" layout for the provided section, supporting horizontal or vertical scrolling.
    ///
    /// - Parameter section: The section to layout.
    /// - Returns: An `NSCollectionLayoutSection` configured for sliding presentation.
    @MainActor public static func slidingLayout(section: CommonCollection.Section) -> NSCollectionLayoutSection {
        let itemLayout = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: section.dimension.autoHeight ? .estimated(44) : .fractionalWidth(1 / resolvedSlidingItemWHRatio(for: section))
            )
        )

        // Show one item plus peek
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(resolvedSlidingGroupWidthRatio(for: section)),
            heightDimension: section.dimension.autoHeight
            ? .estimated(
                CGFloat(44 * section.dimension.numberOfItemsPerGroup)
                + CGFloat(section.dimension.numberOfItemsPerGroup)
                * section.dimension.itemSpacing
            )
                : .fractionalWidth(
                    // Sliding/carousel sections should keep a stable row height; item count expands horizontally.
                    slidingGroupHeightRatio(for: section))
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
                          elementKind: UICollectionView.ReusableKind.header.rawValue,
                          alignment: .topLeading)
                )
            }
            if let footerSize = section.dimension.footerSize {
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
    /// Returns a custom layout for the provided section if available, otherwise falls back to the sliding layout.
    ///
    /// - Parameter section: The section to layout.
    /// - Returns: An `NSCollectionLayoutSection` configured by the custom layout closure or the default sliding layout.
    @MainActor public static func customLayout(section: CommonCollection.Section) -> NSCollectionLayoutSection {
        guard let layout = section.dimension.customLayout else {
            return slidingLayout(section: section)
        }
        return layout(section)
    }
}
