import XCTest
import UIKit
@testable import DesignCore

final class CommonAttributedStringTest: XCTestCase {
    func testBuild_combinesAttributedStringComponents() {
        let built = NSAttributedString.build {
            CommonAttributedString("Hello").foreground(.red)
            CommonAttributedString(" World").font(.systemFont(ofSize: 14))
        }

        XCTAssertEqual(built.string, "Hello World")
    }

    func testAddAttributesToTarget_appliesAttributeToAllMatches() {
        let source = NSAttributedString(string: "hello world hello")
        let highlighted = source.add([.foregroundColor: UIColor.blue], to: "hello")

        let firstRange = (highlighted.string as NSString).range(of: "hello")
        let firstRangeUpperBound = NSMaxRange(firstRange)
        let secondRange = (highlighted.string as NSString).range(
            of: "hello",
            options: [],
            range: NSRange(location: firstRangeUpperBound, length: highlighted.length - firstRangeUpperBound)
        )

        let firstColor = highlighted.attribute(.foregroundColor, at: firstRange.location, effectiveRange: nil) as? UIColor
        let secondColor = highlighted.attribute(.foregroundColor, at: secondRange.location, effectiveRange: nil) as? UIColor

        XCTAssertTrue(firstColor?.isEqual(UIColor.blue) == true)
        XCTAssertTrue(secondColor?.isEqual(UIColor.blue) == true)
    }
}
