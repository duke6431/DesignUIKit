import XCTest
import CoreGraphics
@testable import DesignExts

final class CGSizeExtTest: XCTestCase {
    func testDivision_whenDivisorIsNonZero_returnsDividedSize() {
        let size = CGSize(width: 12, height: 6)
        XCTAssertEqual(size / 3, CGSize(width: 4, height: 2))
    }

    func testDivision_whenDivisorIsZero_returnsZeroSize() {
        let size = CGSize(width: 12, height: 6)
        XCTAssertEqual(size / 0, .zero)
    }
}
