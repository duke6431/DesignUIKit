import XCTest
@testable import DesignCore

final class DateStringExtTest: XCTestCase {
    func testDateFormatted_withCustomTimezone_returnsExpectedText() {
        let date = Date(timeIntervalSince1970: 0)
        let text = date.formatted(using: "yyyy-MM-dd") { formatter in
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            return formatter
        }
        XCTAssertEqual(text, "1970-01-01")
    }

    func testStringDate_whenMatchingFormat_returnsDate() {
        XCTAssertNotNil("2026-01-09".date(using: "yyyy-MM-dd"))
    }

    func testStringReformatted_convertsFormat() {
        let output = "2026-01-09".reformatted(from: "yyyy-MM-dd", to: "dd/MM/yyyy")
        XCTAssertEqual(output, "09/01/2026")
    }

    func testStringRanges_returnsAllOccurrences() {
        let output = "abc abc abc".ranges(of: "abc")
        XCTAssertEqual(output.map(\.location), [0, 4, 8])
    }

    func testStringHelpers_strippedAndCapitalizedFirst() {
        XCTAssertEqual("  hello\n".stripped, "hello")
        XCTAssertEqual("duke".capitalizedFirst, "Duke")
    }
}
