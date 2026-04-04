import XCTest
import Combine
@testable import DesignCombineUIKit

final class BaseUseCaseTest: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    override func tearDown() {
        cancellables = []
        super.tearDown()
    }

    func testUseCase_whenExecute_emitsSingleOutput() {
        struct AddOneUseCase: UseCase {
            func execute(_ input: Int) -> AnyPublisher<Int, Error> {
                Just(input + 1)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        }

        let exp = expectation(description: "publisher emits value")
        var received: Int?

        AddOneUseCase()
            .execute(41)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: {
                    received = $0
                    exp.fulfill()
                }
            )
            .store(in: &cancellables)

        wait(for: [exp], timeout: 1)
        XCTAssertEqual(received, 42)
    }

    func testUseCase_whenInputIsVoid_supportsExecuteWithoutParameters() {
        struct LoadFlagUseCase: UseCase {
            func execute(_ input: Void) -> AnyPublisher<Bool, Error> {
                Just(true)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        }

        let exp = expectation(description: "void publisher emits value")
        var received: Bool?

        LoadFlagUseCase()
            .execute()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: {
                    received = $0
                    exp.fulfill()
                }
            )
            .store(in: &cancellables)

        wait(for: [exp], timeout: 1)
        XCTAssertEqual(received, true)
    }

    func testCompletableUseCase_whenExecute_completes() {
        struct SaveUseCase: CompletableUseCase {
            func execute(_ input: String) -> AnyPublisher<Void, Error> {
                Just(())
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        }

        let exp = expectation(description: "completable publisher finishes")

        SaveUseCase()
            .execute("value")
            .sink(
                receiveCompletion: { completion in
                    if case .finished = completion {
                        exp.fulfill()
                    }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)

        wait(for: [exp], timeout: 1)
    }

    func testStreamUseCase_whenExecute_emitsStreamValues() {
        struct PagingUseCase: StreamUseCase {
            func execute(_ input: Int) -> AnyPublisher<Int, Error> {
                [input, input + 1].publisher
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        }

        let exp = expectation(description: "stream emits all values")
        var received: [Int] = []

        PagingUseCase()
            .execute(5)
            .sink(
                receiveCompletion: { completion in
                    if case .finished = completion {
                        exp.fulfill()
                    }
                },
                receiveValue: { received.append($0) }
            )
            .store(in: &cancellables)

        wait(for: [exp], timeout: 1)
        XCTAssertEqual(received, [5, 6])
    }
}
