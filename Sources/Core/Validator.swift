//
//  Validator.swift
//  ComponentSystem
//
//  Created by Duc IT. Nguyen Minh on 18/05/2022.
//

import Foundation

public typealias Warning = Error

// @objc public protocol AutoFormatter {
//    // TODO: Add autocorrect suggestion/force like amount 1,000,000 where to delete, where put cursor
//    var autoFormatEnable: Bool { get }
//    @objc optional func autoformat(_ data: Any, _ position: Int) throws -> (data: Any, position: Int)
// }

public protocol Validator {
    func validate(_ data: Any) throws -> (status: Bool, comment: Warning?)
}

extension ComponentSystem {
    enum Common: Error {
        case typeNotMatch
    }
}

public struct Validators {
    public enum Rule {
        case none
        case live
        case onSubmit
    }
    public class TextLength: Validator {
        public var autoFormatEnable: Bool = false

//        public func autoformat(_ data: Any, _ pointer: Int) throws -> (data: Any, position: Int) {
//            guard let data = data as? String else { throw ComponentSystem.Common.typeNotMatch }
//
//            return data
//        }

        public func validate(_ data: Any) throws -> (status: Bool, comment: Error?) {
            guard let data = data as? String else { throw ComponentSystem.Common.typeNotMatch }
            if maxLength < 0 && minLength <= 0 { return (true, nil) }
            if data == previousValidValue { return (true, nil) }
            let count = data.count
            switch count {
            case 0:
                if checkEmpty { throw Failure.empty }
                return (true, Warning.empty)
            case let count where count > maxLength:
                throw Failure.max
            case let count where count == maxLength:
                return (true, Warning.max)
            case let count where count < minLength:
                throw Failure.min
            default:
                if data != previousValidValue { previousValidValue = data }
                return (true, nil)
            }
        }

        public enum Failure: Error {
            case max
            case min
            case empty
        }
        public enum Warning: Error {
            case max
            case empty
        }

        // MARK: Configuration
        public var maxLength: Int = -1
        public var minLength: Int = 0
        public var checkEmpty: Bool = false

        // MARK: Internal
        var previousValidValue = ""
    }
}

extension Validators.TextLength.Failure: LocalizedError {
    // TODO: Update failure description
}
