//
//  Array+Test.swift
//
//
//  Created by Duc Minh Nguyen on 4/8/24.
//

import XCTest
import TestBase
@testable import DesignCore

final class ArrayExtTest: XCTestCase {
    var array: [Int]?
    var count: Int?
    
    override func setUpWithError() throws {
        count = Int(arc4random()) % 1000000
        array = Array(0..<(count ?? 0)).map { _ in Int(arc4random()) }
    }

    func testSafeSubscript_whenOutOfRange_returnNil() throws {
        guard let array, let count else {
            throw TestFailure.internalInconsistent.with(\.note, setTo: "Array was not inititalized properly")
        }
        XCTAssertNil(array[safe: -1])
        XCTAssertNil(array[safe: count])
    }
    
    func testSafeSubscript_whenInRange_returnCorrect() throws {
        guard let array, let count else {
            throw TestFailure.internalInconsistent.with(\.note, setTo: "Array was not inititalized properly")
        }
        for _ in 0..<10 {
            let selectedNumber = Int.random(in: 0..<count)
            XCTAssertNotNil(array[safe: selectedNumber])
            XCTAssertEqual(array[safe: selectedNumber], array[selectedNumber])
        }
    }
    

}
