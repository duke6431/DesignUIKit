//
//  Reusable.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2022/06/01.
//
//  This file provides extensions and protocols to simplify registering and dequeuing reusable cells and supplementary views
//  for UICollectionView and UITableView. It includes support for nib-based and class-based registration,
//  as well as automatic reuseIdentifier generation via the Reusable protocol.
//

import UIKit

public extension UICollectionView {
    /// An enum representing the kind of reusable supplementary view supported in BCollectionView.
    ///
    /// - header: Header view for collection section.
    /// - footer: Footer view for collection section.
    enum ReusableKind: String {
        /// Header for collection section
        case header
        /// Footer for collection section
        case footer
        
        /// Return rawValue of Swift
        public var rawValue: String {
            switch self {
            case .header:
                return UICollectionView.elementKindSectionHeader
            case .footer:
                return UICollectionView.elementKindSectionFooter
            }
        }
    }
    
    /// Registers a nib or a UICollectionViewCell object containing a cell with the collection view under a specified identifier.
    ///
    /// - Parameters:
    ///   - aClass: The UICollectionViewCell subclass to register.
    ///   - bundle: The bundle containing the nib file. Defaults to `.main`.
    func register<T: UICollectionViewCell>(_ aClass: T.Type, bundle: Bundle? = .main) {
        let name = String(describing: aClass)
        if bundle?.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forCellWithReuseIdentifier: name)
        } else {
            register(aClass, forCellWithReuseIdentifier: name)
        }
    }
    
    /// Registers a nib or a UICollectionReusableView object containing a header or footer with the collection view under a specified identifier.
    ///
    /// - Parameters:
    ///   - aClass: The UICollectionReusableView subclass to register.
    ///   - kind: The kind of supplementary view to register. Defaults to `.header`.
    ///   - bundle: The bundle containing the nib file. Defaults to `.main`.
    func register<T: UICollectionReusableView>(
        _ aClass: T.Type,
        kind: ReusableKind = .header,
        bundle: Bundle? = .main
    ) {
        let name = String(describing: aClass)
        if bundle?.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: name)
        } else {
            register(aClass, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: name)
        }
    }
    
    /// Returns a reusable collection-view cell object located by its identifier.
    ///
    /// - Parameters:
    ///   - aClass: The UICollectionViewCell subclass to dequeue.
    ///   - indexPath: The index path specifying the location of the cell.
    /// - Returns: A reusable cell of the specified type.
    func dequeue<T: UICollectionViewCell>(_ aClass: T.Type, indexPath: IndexPath) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as? T else {
            fatalError("`\(name)` is not registered")
        }
        return cell
    }
    
    /// Returns a reusable supplementary view (header or footer) located by its identifier.
    ///
    /// - Parameters:
    ///   - aClass: The UICollectionReusableView subclass to dequeue.
    ///   - kind: The kind of supplementary view to dequeue. Defaults to `.header`.
    ///   - indexPath: The index path specifying the location of the supplementary view.
    /// - Returns: A reusable supplementary view of the specified type.
    func dequeue<T: UICollectionReusableView>(
        _ aClass: T.Type,
        kind: ReusableKind = .header,
        indexPath: IndexPath
    ) -> T {
        let name = String(describing: aClass)
        guard let header = dequeueReusableSupplementaryView(ofKind: kind.rawValue, withReuseIdentifier: name, for: indexPath) as? T else {
            fatalError("`\(name)` is not registered")
        }
        return header
    }
}

public extension UITableView {
    /// Registers a nib or a UITableViewCell object containing a cell with the table view under a specified identifier.
    ///
    /// - Parameters:
    ///   - aClass: The UITableViewCell subclass to register.
    ///   - bundle: The bundle containing the nib file. Defaults to `.main`.
    func register<T: UITableViewCell>(_ aClass: T.Type, bundle: Bundle? = .main) {
        let name = String(describing: aClass)
        if bundle?.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forCellReuseIdentifier: name)
        } else {
            register(aClass, forCellReuseIdentifier: name)
        }
    }
    
    /// Returns a reusable table-view cell object located by its identifier.
    ///
    /// - Parameter aClass: The UITableViewCell subclass to dequeue.
    /// - Returns: A reusable cell of the specified type.
    func dequeue<T: UITableViewCell>(_ aClass: T.Type) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withIdentifier: name) as? T else {
            fatalError("`\(name)` is not registered")
        }
        return cell
    }
    
    /// Registers a nib or a UITableViewHeaderFooterView object containing a header or footer with the table view under a specified identifier.
    ///
    /// - Parameters:
    ///   - aClass: The UITableViewHeaderFooterView subclass to register.
    ///   - bundle: The bundle containing the nib file. Defaults to `.main`.
    func register<T: UITableViewHeaderFooterView>(_ aClass: T.Type, bundle: Bundle? = .main) {
        let name = String(describing: aClass)
        if bundle?.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forHeaderFooterViewReuseIdentifier: name)
        } else {
            register(aClass, forHeaderFooterViewReuseIdentifier: name)
        }
    }
    
    /// Returns a reusable header or footer view located by its identifier.
    ///
    /// - Parameter aClass: The UITableViewHeaderFooterView subclass to dequeue.
    /// - Returns: A reusable header or footer view of the specified type.
    func dequeue<T: UITableViewHeaderFooterView>(_ aClass: T.Type) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: name) as? T else {
            fatalError("`\(name)` is not registered")
        }
        return cell
    }
}

/// Protocol for auto detect reuseIdentifier
///
/// Conforming types automatically get a reuseIdentifier string based on their class name.
public protocol Reusable {
    /// The reuse identifier string for the reusable view or cell.
    static var reuseIdentifier: String { get }
}

extension Reusable {
    /// Default implementation returns the class name as the reuse identifier.
    public static var reuseIdentifier: String { .init(describing: Self.self) }
}
