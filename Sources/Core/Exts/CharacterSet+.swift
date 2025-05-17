//
//  CharacterSet+.swift
//  DesignCore
//
//  Created by Duke Nguyen on 2024/01/07.
//
//  Adds computed properties for extracting characters and code points
//  from `CharacterSet`, and a string extension for removing characters.
//

import Foundation

public extension CharacterSet {
    /// An array of `Character` values contained in the `CharacterSet`.
    ///
    /// This property extracts all Unicode scalars from the character set and converts them into `Character` values.
    ///
    /// - Returns: An array of characters represented in the character set.
    var characters: [Character] {
        // A Unicode scalar is any Unicode code point in the range U+0000 to U+D7FF inclusive or U+E000 to U+10FFFF inclusive.
        codePoints.compactMap { UnicodeScalar($0) }.map { Character($0) }
    }
    
    /// An array of Unicode code points (as integers) contained in the `CharacterSet`.
    ///
    /// This property reads the bitmap representation of the character set and extracts the corresponding code points.
    ///
    /// - Returns: An array of Unicode code points in integer form.
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
    /// Returns a new string with all characters from the specified character set removed.
    ///
    /// - Parameter characters: The `CharacterSet` of characters to remove.
    /// - Returns: A new string without the specified characters.
    func remove(allCharactersIn characters: CharacterSet) -> String {
        filter { characters.inverted.characters.contains($0) }
    }
}
