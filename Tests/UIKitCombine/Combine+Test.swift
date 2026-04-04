import XCTest
import Combine
@testable import DesignCombineUIKit

final class CombineExtTest: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }

    func testCompacted_whenPublisherEmitsOptionals_removesNil() {
        let exp = expectation(description: "compacted emits")
        var received: [Int] = []

        [1, nil, 2, nil, 3].publisher
            .compacted()
            .collect()
            .sink { values in
                received = values
                exp.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [exp], timeout: 1)
        XCTAssertEqual(received, [1, 2, 3])
    }

    func testToggle_whenPublisherEmitsBoolean_invertsValues() {
        let exp = expectation(description: "toggle emits")
        var received: [Bool] = []

        [true, false, true].publisher
            .toggle()
            .collect()
            .sink { values in
                received = values
                exp.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [exp], timeout: 1)
        XCTAssertEqual(received, [false, true, false])
    }
}
