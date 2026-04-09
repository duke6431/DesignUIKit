import XCTest
import UIKit
@testable import DesignUIKit

@MainActor
final class CommonCollectionSectionTest: XCTestCase {
    func testSlidingGroupHeightRatio_whenNonAutoHeight_isIndependentOfCellCount() {
        let dimension = CommonCollection.Section.LayoutDimension(
            itemWHRatio: 2,
            autoHeight: false,
            groupWidthRatio: 0.8,
            numberItemsPerGroup: 3
        )
        let sectionWithFewItems = CommonCollection.Section(cells: makeCells(count: 1))
            .with(dimension: dimension)
        let sectionWithManyItems = CommonCollection.Section(cells: makeCells(count: 99))
            .with(dimension: dimension)

        let fewItemsRatio = CommonCollection.Section.slidingGroupHeightRatio(for: sectionWithFewItems)
        let manyItemsRatio = CommonCollection.Section.slidingGroupHeightRatio(for: sectionWithManyItems)

        XCTAssertEqual(fewItemsRatio, manyItemsRatio, accuracy: 0.000_1)
        XCTAssertEqual(fewItemsRatio, 0.8 / 2 / 3, accuracy: 0.000_1)
    }
    
    func testSlidingGroupHeightRatio_whenHorizontalAndMultipleItemsPerGroup_scalesPerItemWidth() {
        let dimension = CommonCollection.Section.LayoutDimension(
            itemWHRatio: 2.0 / 3.0,
            autoHeight: false,
            groupAxis: .horizontal,
            groupWidthRatio: 1,
            numberItemsPerGroup: 2
        )
        let section = CommonCollection.Section(cells: makeCells(count: 2))
            .with(dimension: dimension)

        let ratio = CommonCollection.Section.slidingGroupHeightRatio(for: section)

        XCTAssertEqual(ratio, 0.75, accuracy: 0.000_1)
    }
    
    func testSlidingGroupHeightRatio_whenRatiosAreInvalid_fallsBackToFiniteDefaults() {
        let dimension = CommonCollection.Section.LayoutDimension(
            itemWHRatio: 0,
            autoHeight: false,
            groupWidthRatio: -1
        )
        let section = CommonCollection.Section(cells: makeCells(count: 5))
            .with(dimension: dimension)

        let ratio = CommonCollection.Section.slidingGroupHeightRatio(for: section)

        XCTAssertEqual(ratio, 1, accuracy: 0.000_1)
    }
}

private extension CommonCollectionSectionTest {
    func makeCells(count: Int) -> [CommonCollectionCellModel] {
        (0..<count).map { TestCollectionCellModel(identifier: "item-\($0)") }
    }
}

private final class TestCollectionCellModel: NSObject, CommonCollectionCellModel {
    let identifier: String
    let selectable: Bool = true
    let customConfiguration: (@Sendable (CommonCollection.CollectionCell) -> Void)? = nil
    var realData: Sendable? { identifier }

    init(identifier: String) {
        self.identifier = identifier
    }

    static var cellKind: CommonCollection.CollectionCell.Type { TestCollectionCell.self }
}

private final class TestCollectionCell: CommonCollection.CollectionCell {
    override func bind(_ model: CommonCollectionCellModel) {
        identifier = model.identifier
    }
}
