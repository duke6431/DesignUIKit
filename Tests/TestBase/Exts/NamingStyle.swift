//
//  File.swift
//  ComponentSystem
//
//  Created by Duke Nguyen on 1/10/24.
//

import Foundation

public enum NamingStyle {
    public enum WordStyle {
        case capitalized
        case uppercased
        case lowercased
    }
    
    case camelCase
    case snakeCase
    case word(style: WordStyle)
    case custom(delimiter: String)
    
    var separator: String {
        switch self {
        case .camelCase: ""
        case .snakeCase: "_"
        case .word: " "
        case .custom(let delimiter): delimiter
        }
    }
    
    func words(from text: String) -> [String] {
        switch self {
        case .camelCase:
            text.unicodeScalars.dropFirst().reduce(String(text.prefix(1))) {
                CharacterSet.uppercaseLetters.contains($1) ? $0 + " " + String($1) : $0 + String($1)
            }.components(separatedBy: .init(charactersIn: " ")).filter { !$0.isEmpty }
        default:
            text.components(separatedBy: .init(charactersIn: separator))
        }
    }
}

extension Array where Element == String {
    func to(style: NamingStyle) -> String {
        switch style {
        case .camelCase:
            map(\.capitalized).joined()
        case .word(let type):
            switch type {
            case .capitalized:
                map(\.capitalized).joined(separator: style.separator)
            case .lowercased:
                map { $0.lowercased() }.joined(separator: style.separator)
            case .uppercased:
                map { $0.uppercased() }.joined(separator: style.separator)
            }
        default:
            map { $0.lowercased() }.joined(separator: style.separator)
        }
    }
}

extension String {
    func converted(from lhs: NamingStyle, to rhs: NamingStyle) -> String {
        lhs.words(from: self).to(style: rhs)
    }
}
