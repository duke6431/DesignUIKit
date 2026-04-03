import XCTest
import UIKit
@testable import DesignUIKit

@MainActor
final class RiskRegressionTest: XCTestCase {
    func testDeleteItem_whenIdentifierIsMissing_doesNotMutateFirstRow() {
        let sut = makeTableView()
        sut.reloadData(sections: [
            .init(items: [TableItem(id: "a"), TableItem(id: "b")])
        ])

        sut.deleteItem(with: "missing")

        XCTAssertEqual(sut.numberOfSections, 1)
        XCTAssertEqual(sut.numberOfRows(inSection: 0), 2)
    }

    func testDeleteItem_whenFilteredAndIdentifierNotInSearchResults_keepsSearchStateConsistent() {
        let sut = makeTableView()
        sut.reloadData(sections: [
            .init(items: [TableItem(id: "alpha"), TableItem(id: "beta")])
        ])
        sut.search(with: "alpha")
        XCTAssertEqual(sut.numberOfRows(inSection: 0), 1)

        sut.deleteItem(with: "beta")
        XCTAssertEqual(sut.numberOfRows(inSection: 0), 1)

        sut.deleteItem(with: "alpha")
        XCTAssertEqual(sut.numberOfSections, 0)
    }

    func testFStack_whenDidMoveToSuperviewCalledAgain_doesNotDuplicateArrangedSubviews() {
        let label = FLabel("Title")
        let sut = FStack(axis: .vertical, arrangedContents: [label])
        let container = UIView(frame: .init(x: 0, y: 0, width: 200, height: 200))

        container.addSubview(sut)
        sut.didMoveToSuperview()

        XCTAssertEqual(sut.arrangedSubviews.count, 1)
    }

    func testFZStack_whenDidMoveToSuperviewCalledAgain_doesNotDuplicateSubviews() {
        let label = FLabel("A")
        let sut = FZStack(contentViews: [label])
        let container = UIView(frame: .init(x: 0, y: 0, width: 200, height: 200))

        container.addSubview(sut)
        sut.didMoveToSuperview()

        XCTAssertEqual(sut.subviews.filter { $0 === label }.count, 1)
    }

    func testFSwitch_whenDidMoveToSuperviewCalledAgain_doesNotDuplicateGesturesOrContent() {
        let sut = FSwitch()
        let container = UIView(frame: .init(x: 0, y: 0, width: 200, height: 200))

        container.addSubview(sut)
        sut.didMoveToSuperview()

        XCTAssertEqual(sut.gestureRecognizers?.count, 2)
        XCTAssertEqual(sut.subviews.count, 2)
    }

    func testFScroll_whenDidMoveToSuperviewCalledAgain_doesNotDuplicateContentViews() {
        let first = FLabel("1")
        let second = FLabel("2")
        let sut = FScroll(axis: .vertical) {
            first
            second
        }
        let container = UIView(frame: .init(x: 0, y: 0, width: 200, height: 200))

        container.addSubview(sut)
        sut.didMoveToSuperview()

        XCTAssertEqual(sut.subviews.filter { $0 === first || $0 === second }.count, 2)
    }
}

private extension RiskRegressionTest {
    func makeTableView() -> CommonTableView {
        .init(map: [TableItem.self])
    }
}

private final class TableItem: NSObject, CommonCellModel {
    let identifier: String
    var selectable: Bool = true
    var customConfiguration: ((CommonTableView.TableCell) -> Void)?
#if os(iOS)
    var leadingActions: [UIContextualAction] = []
    var trailingActions: [UIContextualAction] = []
#endif
    var realData: Any? { identifier }

    init(id: String) {
        self.identifier = id
    }

    static var cellKind: CommonTableView.TableCell.Type { TableItemCell.self }

    @objc func isHighlighted(with keyword: String) -> Bool {
        identifier.contains(keyword)
    }
}

private final class TableItemCell: CommonTableView.TableCell {
    override func bind(_ model: CommonCellModel, highlight text: String) {
        identifier = model.identifier
    }
}
