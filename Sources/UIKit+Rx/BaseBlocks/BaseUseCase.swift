//
//  BaseUseCase.swift
//  DesignRxUIKit
//
//  Created by Duke Nguyen on 2026/04/03.
//
//  Defines reactive use-case contracts for MVVM+Navigator architecture.
//  The base package provides only abstractions; feature modules provide implementations.
//

import RxSwift

/// A reactive use-case contract that maps an input to a single async output.
///
/// - Important: This module is intentionally contract-only.
///   Put feature/domain business logic implementations outside `DesignRxUIKit`.
public protocol UseCase<Input, Output> {
    associatedtype Input
    associatedtype Output

    /// Executes the use case with the given input.
    /// - Parameter input: Input for the business intent.
    /// - Returns: A `Single` that emits one output or an error.
    func execute(_ input: Input) -> Single<Output>
}

/// A reactive use-case contract that performs work and only signals completion or error.
public protocol CompletableUseCase<Input> {
    associatedtype Input

    /// Executes the use case with the given input.
    /// - Parameter input: Input for the business intent.
    /// - Returns: A `Completable` signaling completion or failure.
    func execute(_ input: Input) -> Completable
}

/// A reactive use-case contract that maps an input to a stream of values.
public protocol StreamUseCase<Input, Element> {
    associatedtype Input
    associatedtype Element

    /// Executes the use case with the given input.
    /// - Parameter input: Input for the business intent.
    /// - Returns: An `Observable` stream of values.
    func execute(_ input: Input) -> Observable<Element>
}

public extension UseCase where Input == Void {
    /// Executes a no-input use case.
    func execute() -> Single<Output> {
        execute(())
    }
}

public extension CompletableUseCase where Input == Void {
    /// Executes a no-input use case.
    func execute() -> Completable {
        execute(())
    }
}

public extension StreamUseCase where Input == Void {
    /// Executes a no-input use case.
    func execute() -> Observable<Element> {
        execute(())
    }
}

/// Backward-compatible aliases that follow existing `*ing` naming style.
public typealias UseCaseing<Input, Output> = UseCase<Input, Output>
public typealias CompletableUseCaseing<Input> = CompletableUseCase<Input>
public typealias StreamUseCaseing<Input, Element> = StreamUseCase<Input, Element>
