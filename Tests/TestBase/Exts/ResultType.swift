//
//  File.swift
//  ComponentSystem
//
//  Created by Duke Nguyen on 1/10/24.
//

import Foundation

public enum ResultType<T> {
    case success(T)
    case failure(Error)
}
