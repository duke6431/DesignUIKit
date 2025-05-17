//
//  ObjectAssociation.swift
//  DesignCore
//
//  Created by Duc Minh Nguyen on 1/21/23.
//

import Foundation
import ObjectiveC

/**
 A utility class that enables the creation of associated properties for any class using Swift extensions.
 
 This class leverages Objective-C runtime functions to associate an object of type `T` with any other object,
 allowing you to add stored properties to classes in extensions.
 
 Usage example:
 ```
 extension SomeType {
 private static let association = ObjectAssociation<NSObject>()
 
 var simulatedProperty: NSObject? {
 get { return Self.association[self] }
 set { Self.association[self] = newValue }
 }
 }
 ```
 */
public final class ObjectAssociation<T: AnyObject> {
    private let policy: objc_AssociationPolicy
    
    /**
     Initializes a new instance of `ObjectAssociation` with a specified association policy.
     
     - Parameter policy: The Objective-C association policy to use when linking objects. Defaults to `.OBJC_ASSOCIATION_RETAIN_NONATOMIC`.
     */
    public init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        self.policy = policy
    }
    
    /**
     Accesses the associated object for the given index object.
     
     - Parameter index: The object to which the associated object is linked.
     - Returns: The associated object of type `T` if it exists; otherwise, `nil`.
     */
    public subscript(index: AnyObject) -> T? {
        get { objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as? T }
        set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) }
    }
}

/**
 A helper class that wraps a closure with no parameters and no return value.
 
 This class can be used to store and invoke closures, especially useful when associating closures with Objective-C APIs.
 */
@objc public class ClosureSleeve: NSObject {
    /// The closure to be stored and invoked.
    public let closure: () -> Void
    
    /**
     Initializes a new `ClosureSleeve` with the given closure.
     
     - Parameter closure: The closure to store.
     */
    public init(_ closure: @escaping() -> Void) { self.closure = closure }
    
    /// Invokes the stored closure.
    @objc public func invoke() { closure() }
    
    /// Allows the instance to be called like a function to invoke the closure.
    public func callAsFunction() { invoke() }
}

/**
 A helper class that wraps a closure with a single parameter and no return value.
 
 This class can be used to store and invoke closures that take one argument, useful for Objective-C interoperability.
 */
public class GenericClosureSleeve<T>: NSObject {
    /// The closure to be stored and invoked.
    public let closure: (T) -> Void
    
    /**
     Initializes a new `GenericClosureSleeve` with the given closure.
     
     - Parameter closure: The closure to store that takes a parameter of type `T`.
     */
    public init(_ closure: @escaping (T) -> Void) { self.closure = closure }
    
    /**
     Invokes the stored closure with the provided value.
     
     - Parameter value: The value to pass to the closure.
     */
    public func invoke(_ value: T) { closure(value) }
    
    /// Allows the instance to be called like a function with a parameter to invoke the closure.
    public func callAsFunction(_ value: T) { invoke(value) }
}

/**
 A wrapper class for storing a value of any type `T` in an `NSObject` subclass.
 
 This is useful when you need to associate a struct or value type with an Objective-C object.
 */
public class StructWrapper<T>: NSObject {
    /// The wrapped value.
    public var value: T
    
    /**
     Initializes a new `StructWrapper` with the given value.
     
     - Parameter value: The value to wrap.
     */
    public init(value: T) { self.value = value }
    
    /// Returns the wrapped value when the instance is called like a function.
    public func callAsFunction() -> T { value }
}
