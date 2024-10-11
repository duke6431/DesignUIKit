//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 1/10/24.
//

import Foundation

enum FailureType: String {
    case internalInconsistent
    
    var title: String { rawValue.converted(from: .snakeCase, to: .camelCase) }
}

extension TestFailure {
    public static var internalInconsistent: TestFailure { .init(type: .internalInconsistent) }
}
