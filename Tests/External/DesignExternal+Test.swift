import XCTest
import DesignExternal

final class DesignExternalTest: XCTestCase {
    func testPathExported_supportsDirectoryLifecycle() throws {
        let path = Path.uniqueTemporary
        XCTAssertFalse(path.exists)

        try path.createDirectory()
        XCTAssertTrue(path.exists)

        try path.deleteFile()
        XCTAssertFalse(path.exists)
    }
}
