import XCTest
import Combine
import DesignCore
@testable import DesignCombineUIKit

final class FObservedPreferenceTest: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }

    @MainActor
    func testWrappedValue_whenUpdated_persistsToUserDefaults() {
        let key: FPreferenceKey = "designuikit.combine.preference.persist"
        defer { UserDefaults.standard.removeObject(forKey: key.rawValue) }

        let sut = FObservedPreference<Int>(key, default: 10)
        XCTAssertEqual(sut.wrappedValue, 10)

        sut.wrappedValue = 42
        XCTAssertEqual(UserDefaults.standard.object(forKey: key.rawValue) as? Int, 42)
    }

    @MainActor
    func testProjectedValue_whenWrappedValueChanges_emitsUpdatedValue() {
        let key: FPreferenceKey = "designuikit.combine.preference.publisher"
        defer { UserDefaults.standard.removeObject(forKey: key.rawValue) }

        let sut = FObservedPreference<Int>(key, default: 0)
        let exp = expectation(description: "preference publisher emits")

        sut.projectedValue
            .sink { value in
                if value == 99 {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.wrappedValue = 99

        wait(for: [exp], timeout: 1)
    }
}
