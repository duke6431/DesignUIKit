import XCTest
@testable import DesignCore

final class CharacterSetExtTest: XCTestCase {
    func testRemoveAllCharactersIn_whenContainsDigits_removesDigits() {
        XCTAssertEqual("a1b2c3".remove(allCharactersIn: .decimalDigits), "abc")
    }

    func testRemoveAllCharactersIn_whenNoMatchingCharacters_returnsOriginal() {
        XCTAssertEqual("hello".remove(allCharactersIn: .decimalDigits), "hello")
    }
}
