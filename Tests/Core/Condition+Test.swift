import XCTest
@testable import DesignCore

private struct ConditionModel: Conditionable, Equatable {
    let value: Int
}

final class ConditionExtTest: XCTestCase {
    func testIf_whenConditionIsTrue_appliesTransform() {
        let output = ConditionModel(value: 10).`if`(true) { .init(value: $0.value + 5) }
        XCTAssertEqual(output, .init(value: 15))
    }

    func testIf_whenConditionIsFalse_returnsSelf() {
        let output = ConditionModel(value: 10).`if`(false) { .init(value: $0.value + 5) }
        XCTAssertEqual(output, .init(value: 10))
    }

    func testIfOptional_whenValueExists_appliesTransform() {
        let output = ConditionModel(value: 2).`if`(3) { model, number in
            .init(value: model.value * number)
        }
        XCTAssertEqual(output, .init(value: 6))
    }

    func testSwitch_whenNoCaseMatch_usesDefault() {
        let output = ConditionModel(value: 1).`switch`(
            99,
            cases: [1: { .init(value: $0.value + 1) }],
            default: { .init(value: $0.value + 10) }
        )
        XCTAssertEqual(output, .init(value: 11))
    }

    func testWrapped_appliesTransform() {
        let output = ConditionModel(value: 7).wrapped { .init(value: $0.value - 2) }
        XCTAssertEqual(output, .init(value: 5))
    }
}
