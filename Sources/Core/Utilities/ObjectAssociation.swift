//
//  ObjectAssociation.swift
//  DesignCore
//
//  Created by Duke Nguyen on 2023/01/21.
//
//  Provides support for associating objects and closures using Objective-C runtime,
//  enabling stored property-like behavior in Swift extensions.
//

import Foundation
import ObjectiveC

/// Enables stored property-like behavior for any class via associated objects.
/// Useful for adding data to existing types in Swift extensions.
public final class ObjectAssociation<T: AnyObject> {
    private let policy: objc_AssociationPolicy
    
    /// Creates an association handler with a specified Objective-C memory policy.
    /// - Parameter policy: The association policy. Default is `.OBJC_ASSOCIATION_RETAIN_NONATOMIC`.
    public init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        self.policy = policy
    }
    
    /// Gets or sets the associated object for the given instance.
    /// - Parameter index: The object to associate with.
    /// - Returns: The associated value, if present.
    public subscript(index: AnyObject) -> T? {
        get { objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as? T }
        set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) }
    }
}

/// A wrapper for storing and invoking a parameterless closure.
/// Commonly used with Objective-C targets or selectors.
@objc public class ClosureSleeve: NSObject {
    /// The closure to invoke.
    public let closure: () -> Void
    
    /// Initializes the wrapper with a closure.
    /// - Parameter closure: The closure to store.
    public init(_ closure: @escaping() -> Void) { self.closure = closure }
    
    /// Executes the stored closure.
    @objc public func invoke() { closure() }
    
    /// Invokes the stored closure using function-call syntax.
    public func callAsFunction() { invoke() }
}

/// A wrapper for storing and invoking a closure with a single argument.
/// Useful for bridging Swift closures with Objective-C APIs.
public class GenericClosureSleeve<T>: NSObject {
    /// The closure to invoke with an argument.
    public let closure: (T) -> Void
    
    /// Initializes the wrapper with a typed closure.
    /// - Parameter closure: A closure accepting one argument.
    public init(_ closure: @escaping (T) -> Void) { self.closure = closure }
    
    /// Executes the stored closure with a provided value.
    /// - Parameter value: The value to pass into the closure.
    public func invoke(_ value: T) { closure(value) }
    
    /// Invokes the closure using function-call syntax with a parameter.
    /// - Parameter value: The argument for the closure.
    public func callAsFunction(_ value: T) { invoke(value) }
}

/// A container for wrapping any value type as an `NSObject`.
/// Useful for associating value types with Objective-C-compatible objects.
public class StructWrapper<T>: NSObject {
    /// The wrapped value.
    public var value: T
    
    /// Initializes the wrapper with a value.
    /// - Parameter value: The value to wrap.
    public init(value: T) { self.value = value }
    
    /// Returns the wrapped value using function-call syntax.
    public func callAsFunction() -> T { value }
}
