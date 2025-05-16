//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 1/7/24.
//

import Foundation

public extension Date {
    /// Free style date formatter
    func formatted(using format: String, _ customized: ((DateFormatter) -> DateFormatter)? = nil) -> String {
        let formatter = DateFormatter()
        formatter.locale = .autoupdatingCurrent
        formatter.dateFormat = format
        return (customized?(formatter) ?? formatter).string(from: self)
    }
}

public extension String {
    /// Extract date from self using format
    func date(using format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = .autoupdatingCurrent
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    
    /// Reformat current date string to new date format
    func reformatted(from format: String, to target: String) -> String? {
        let formatter = DateFormatter()
        formatter.locale = .autoupdatingCurrent
        formatter.dateFormat = format
        guard let date = formatter.date(from: self) else { return nil }
        formatter.dateFormat = target
        return formatter.string(from: date)
    }
}
