import XCTest
import RxSwift
@testable import DesignRxUIKit

final class BaseUseCaseTest: XCTestCase {
    private var disposeBag = DisposeBag()

    override func tearDown() {
        disposeBag = DisposeBag()
        super.tearDown()
    }

    func testUseCaseing_whenExecute_emitsSingleOutput() {
        struct AddOneUseCase: UseCase {
            func execute(_ input: Int) -> Single<Int> {
                .just(input + 1)
            }
        }

        let exp = expectation(description: "single emits value")
        var received: Int?

        AddOneUseCase()
            .execute(41)
            .subscribe(
                onSuccess: {
                    received = $0
                    exp.fulfill()
                },
                onFailure: { _ in }
            )
            .disposed(by: disposeBag)

        wait(for: [exp], timeout: 1)
        XCTAssertEqual(received, 42)
    }

    func testUseCaseing_whenInputIsVoid_supportsExecuteWithoutParameters() {
        struct LoadFlagUseCase: UseCase {
            func execute(_ input: Void) -> Single<Bool> {
                .just(true)
            }
        }

        let exp = expectation(description: "void single emits value")
        var received: Bool?

        LoadFlagUseCase()
            .execute()
            .subscribe(
                onSuccess: {
                    received = $0
                    exp.fulfill()
                },
                onFailure: { _ in }
            )
            .disposed(by: disposeBag)

        wait(for: [exp], timeout: 1)
        XCTAssertEqual(received, true)
    }

    func testCompletableUseCaseing_whenExecute_completes() {
        struct SaveUseCase: CompletableUseCase {
            func execute(_ input: String) -> Completable {
                .empty()
            }
        }

        let exp = expectation(description: "completable completes")

        SaveUseCase()
            .execute("value")
            .subscribe(
                onCompleted: { exp.fulfill() },
                onError: { _ in }
            )
            .disposed(by: disposeBag)

        wait(for: [exp], timeout: 1)
    }

    func testStreamUseCaseing_whenExecute_emitsStreamValues() {
        struct PagingUseCase: StreamUseCase {
            func execute(_ input: Int) -> Observable<Int> {
                Observable.from([input, input + 1])
            }
        }

        let exp = expectation(description: "observable emits all values")
        var received: [Int] = []

        PagingUseCase()
            .execute(5)
            .subscribe(
                onNext: { received.append($0) },
                onCompleted: { exp.fulfill() }
            )
            .disposed(by: disposeBag)

        wait(for: [exp], timeout: 1)
        XCTAssertEqual(received, [5, 6])
    }
}
