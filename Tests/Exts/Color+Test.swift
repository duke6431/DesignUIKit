import XCTest
import UIKit
@testable import DesignExts

final class UIColorExtTest: XCTestCase {
    func testHexString_whenUsingRGBColor_returnsExpectedValue() {
        let color = UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)
        XCTAssertEqual(color.hexString, "#FF8000")
    }

    func testHexString_whenUsingWhiteColor_returnsExpectedValue() {
        let color = UIColor(white: 0.5, alpha: 1)
        XCTAssertEqual(color.hexString, "#808080")
    }

    func testHexInitializer_whenUsingThreeDigitCode_expandsCorrectly() {
        let color = UIColor(hexString: "F0A")
        XCTAssertEqual(color.hexString, "#FF00AA")
    }
}
