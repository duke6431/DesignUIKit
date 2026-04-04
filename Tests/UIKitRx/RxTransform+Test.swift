import XCTest
import RxSwift
@testable import DesignRxUIKit

final class RxTransformTest: XCTestCase {
    private var disposeBag = DisposeBag()

    override func tearDown() {
        disposeBag = DisposeBag()
        super.tearDown()
    }

    func testCompacted_whenObservableHasNil_filtersNilValues() {
        let exp = expectation(description: "compacted emits all values")
        var received: [Int] = []

        Observable.from([1 as Int?, nil, 2, nil, 3])
            .compacted()
            .subscribe(
                onNext: { received.append($0) },
                onCompleted: { exp.fulfill() }
            )
            .disposed(by: disposeBag)

        wait(for: [exp], timeout: 1)
        XCTAssertEqual(received, [1, 2, 3])
    }

    func testToggle_whenObservableHasBooleans_invertsValues() {
        let exp = expectation(description: "toggle emits all values")
        var received: [Bool] = []

        Observable.from([true, false, true])
            .toggle()
            .subscribe(
                onNext: { received.append($0) },
                onCompleted: { exp.fulfill() }
            )
            .disposed(by: disposeBag)

        wait(for: [exp], timeout: 1)
        XCTAssertEqual(received, [false, true, false])
    }
}
