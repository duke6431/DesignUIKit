//
//  UITableView+.swift
//
//  Created by Son le on 1/11/21.
//

import UIKit

extension UICollectionView {
    /// Registers a nib or a UICollectionViewCell object containing a cell with the collection view under a specified identifier.
    func register<T: UICollectionViewCell>(_ aClass: T.Type, bundle: Bundle? = .main) {
        let name = String(describing: aClass)
        if bundle?.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forCellWithReuseIdentifier: name)
        } else {
            register(aClass, forCellWithReuseIdentifier: name)
        }
    }

    /// Returns a reusable collection-view cell object located by its identifier.
    func dequeue<T: UICollectionViewCell>(_ aClass: T.Type, indexPath: IndexPath) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as? T else {
            fatalError("`\(name)` is not registered")
        }
        return cell
    }
}

extension UITableView {
    /// Registers a nib or a UITableViewCell object containing a cell with the table view under a specified identifier.
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
    func dequeue<T: UITableViewCell>(_ aClass: T.Type) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withIdentifier: name) as? T else {
            fatalError("`\(name)` is not registered")
        }
        return cell
    }

    /// Registers a nib or a UITableViewHeaderFooterView object containing a header or footer with the table view under a specified identifier.
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
    func dequeue<T: UITableViewHeaderFooterView>(_ aClass: T.Type) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: name) as? T else {
            fatalError("`\(name)` is not registered")
        }
        return cell
    }
}

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
