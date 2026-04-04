import XCTest
@testable import DesignCore

final class PreferencesTest: XCTestCase {
    private var store: UserDefaults!
    private var suiteName: String!

    override func setUpWithError() throws {
        suiteName = "DesignCoreTests.\(UUID().uuidString)"
        guard let defaults = UserDefaults(suiteName: suiteName) else {
            XCTFail("Unable to create UserDefaults suite")
            return
        }
        defaults.removePersistentDomain(forName: suiteName)
        store = defaults
    }

    override func tearDownWithError() throws {
        if let suiteName, let store {
            store.removePersistentDomain(forName: suiteName)
        }
        store = nil
        suiteName = nil
    }

    func testPreferenceItem_whenNoStoredValue_usesAndPersistsDefault() {
        guard let store else { return }
        var item = PreferenceItem("pref.bool", false, store: store)
        XCTAssertEqual(item.wrappedValue, false)
        XCTAssertEqual(store.object(forKey: "pref.bool") as? Bool, false)

        item.wrappedValue = true
        XCTAssertEqual(item.wrappedValue, true)
        XCTAssertEqual(store.object(forKey: "pref.bool") as? Bool, true)
    }

    func testPreferenceItem_whenCalculatedValueProvided_returnsTransformedValue() {
        guard let store else { return }
        let item = PreferenceItem("pref.name", "duke", { $0.uppercased() }, store: store)
        XCTAssertEqual(item.wrappedValue, "DUKE")
    }

    func testPreferenceData_roundTripsCodableValue() {
        guard let store else { return }
        struct Profile: Codable, Equatable {
            let name: String
            let age: Int
        }

        var item = PreferenceData("pref.profile", Profile(name: "unknown", age: 0), store: store)
        XCTAssertEqual(item.wrappedValue, Profile(name: "unknown", age: 0))

        item.wrappedValue = Profile(name: "duke", age: 30)
        XCTAssertEqual(item.wrappedValue, Profile(name: "duke", age: 30))
    }
}
