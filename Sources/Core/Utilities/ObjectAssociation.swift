//
//  ObjectAssociation.swift
//  DesignCore
//
//  Created by Duc Minh Nguyen on 1/21/23.
//

import Foundation
import ObjectiveC

/**
 Create associated property for class using extensions
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

    /// - Parameter policy: An association policy that will be used when linking objects.
    public init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        self.policy = policy
    }

    /// Accesses associated object.
    /// - Parameter index: An object whose associated object is to be accessed.
    public subscript(index: AnyObject) -> T? {
        get { objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as? T }
        set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) }
    }
}

@objc public class ClosureSleeve: NSObject {
    public let closure: () -> Void
    
    public init(_ closure: @escaping() -> Void) { self.closure = closure }
    
    @objc public func invoke() { closure() }
    
    public func callAsFunction() { invoke() }
}

public class GenericClosureSleeve<T>: NSObject {
    public let closure: (T) -> Void
    
    public init(_ closure: @escaping (T) -> Void) { self.closure = closure }
    
    public func invoke(_ value: T) { closure(value) }
    
    public func callAsFunction(_ value: T) { invoke(value) }
}

public class StructWrapper<T>: NSObject {
    public var value: T
    
    public init(value: T) { self.value = value }
    
    public func callAsFunction() -> T { value }
}
