import XCTest
import UIKit
@testable import DesignUIKit

@MainActor
final class CommonCollectionViewTest: XCTestCase {
    func testDidSelectItemAt_whenIndexPathIsOutOfRange_ignoresSelection() {
        let sut = makeSUT()
        let delegate = SpyCollectionDelegate()
        sut.commonDelegate = delegate
        sut.reloadData(sections: [makeSection(cells: [CellModel(identifier: "0")])])

        sut.collectionView(sut, didSelectItemAt: .init(item: 99, section: 0))
        sut.collectionView(sut, didSelectItemAt: .init(item: 0, section: 99))

        XCTAssertTrue(delegate.selectedIDs.isEmpty)
    }

    func testDidSelectItemAt_whenIndexPathIsValid_notifiesDelegate() {
        let sut = makeSUT()
        let delegate = SpyCollectionDelegate()
        sut.commonDelegate = delegate
        sut.reloadData(sections: [makeSection(cells: [CellModel(identifier: "selected")])])

        sut.collectionView(sut, didSelectItemAt: .init(item: 0, section: 0))

        XCTAssertEqual(delegate.selectedIDs, ["selected"])
    }
}

private extension CommonCollectionViewTest {
    func makeSUT() -> CommonCollection.View {
        .init(itemMapper: [CellModel.self], sectionMapper: [])
    }

    func makeSection(cells: [CommonCollectionCellModel]) -> CommonCollection.Section {
        .init(cells: cells).with(layout: { _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(44)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: itemSize,
                subitems: [item]
            )
            return NSCollectionLayoutSection(group: group)
        })
    }
}

private final class SpyCollectionDelegate: NSObject, CommonCollectionViewDelegate {
    private(set) var selectedIDs: [String] = []

    @objc func didSelectCell(at indexPath: IndexPath, with data: CommonCollectionCellModel) {
        selectedIDs.append(data.identifier)
    }
}

private final class CellModel: NSObject, CommonCollectionCellModel {
    let identifier: String
    let customConfiguration: (@Sendable (CommonCollection.CollectionCell) -> Void)? = nil
    let selectable: Bool = true
    var realData: Sendable? { identifier }

    init(identifier: String) {
        self.identifier = identifier
    }

    static var cellKind: CommonCollection.CollectionCell.Type { TestCell.self }
}

private final class TestCell: CommonCollection.CollectionCell {
    override func bind(_ model: CommonCollectionCellModel) {
        identifier = model.identifier
    }
}
