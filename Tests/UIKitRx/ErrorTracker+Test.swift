import XCTest
import RxSwift
@testable import DesignRxUIKit

final class ErrorTrackerTest: XCTestCase {
    private var disposeBag = DisposeBag()

    override func tearDown() {
        disposeBag = DisposeBag()
        super.tearDown()
    }

    func testTrackError_whenSourceErrors_forwardsErrorToTracker() {
        enum MockError: Error {
            case boom
        }

        let tracker = ErrorTracker()
        let trackerExp = expectation(description: "tracker receives error")
        let sourceExp = expectation(description: "source emits value then errors")
        var trackedErrors: [Error] = []
        var receivedValues: [Int] = []

        tracker.asObservable()
            .subscribe(onNext: { error in
                trackedErrors.append(error)
                trackerExp.fulfill()
            })
            .disposed(by: disposeBag)

        let source = Observable<Int>.create { observer in
            observer.onNext(1)
            observer.onError(MockError.boom)
            return Disposables.create()
        }

        source.trackError(tracker)
            .subscribe(
                onNext: { receivedValues.append($0) },
                onError: { _ in sourceExp.fulfill() }
            )
            .disposed(by: disposeBag)

        wait(for: [trackerExp, sourceExp], timeout: 1)
        XCTAssertEqual(receivedValues, [1])
        XCTAssertEqual(trackedErrors.count, 1)
        XCTAssertTrue(trackedErrors.first is MockError)
    }
}
