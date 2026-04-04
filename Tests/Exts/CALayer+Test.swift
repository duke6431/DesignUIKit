import XCTest
import UIKit
@testable import DesignExts

@MainActor
final class CALayerExtTest: XCTestCase {
    func testAddShadow_whenPathIsNil_clearsExistingPath() {
        let layer = CALayer()
        let firstPath = UIBezierPath(rect: .init(x: 0, y: 0, width: 10, height: 10)).cgPath

        layer.addShadow(path: firstPath)
        XCTAssertNotNil(layer.shadowPath)

        layer.addShadow(path: nil)
        XCTAssertNil(layer.shadowPath)
    }

    func testRemoveShadow_resetsMainShadowProperties() {
        let layer = CALayer()
        layer.addShadow(offSet: .init(width: 3, height: 4), opacity: 0.4, radius: 8, color: .red)
        layer.removeShadow()

        XCTAssertEqual(layer.shadowOffset, .zero)
        XCTAssertEqual(layer.shadowOpacity, 0)
        XCTAssertEqual(layer.shadowRadius, 0)
        XCTAssertNil(layer.shadowPath)
    }
}
