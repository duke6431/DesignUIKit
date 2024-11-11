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
        for (offset, elem) in bitmapRepresentation.enumerated() {
            let remainer = offset % 0x2001
            if remainer == 0x2000 {
                // plane index byte
                plane = Int(elem) << 13
                continue
            }
            let base = (plane + remainer) << 3
            for offset in 0 ..< 8 where elem & 1 << offset != 0 {
                result.append(base + offset)
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
