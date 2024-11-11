//
//  File.swift
//
//
//  Created by Duc Minh Nguyen on 1/7/24.
//

import Foundation

public extension CharacterSet {
    /// Get raw character array of a predefined/custom created CharacterSet
    var characters: [Character] {
        // A Unicode scalar is any Unicode code point in the range U+0000 to U+D7FF inclusive or U+E000 to U+10FFFF inclusive.
        codePoints.compactMap { UnicodeScalar($0) }.map { Character($0) }
    }

    /// Convert character in CharacterSet to code point (HEX)
    var codePoints: [Int] {
        var result: [Int] = []
        var plane = 0
        // following documentation at https://developer.apple.com/documentation/foundation/nscharacterset/1417719-bitmaprepresentation
        for (i, w) in bitmapRepresentation.enumerated() {
            let k = i % 0x2001
            if k == 0x2000 {
                // plane index byte
                plane = Int(w) << 13
                continue
            }
            let base = (plane + k) << 3
            for j in 0 ..< 8 where w & 1 << j != 0 {
                result.append(base + j)
            }
        }
        return result
    }
}

public extension String {
    /// Filter all characters in certain CharacterSet
    func remove(allCharactersIn characters: CharacterSet) -> String {
        filter { characters.inverted.characters.contains($0) }
    }
}
