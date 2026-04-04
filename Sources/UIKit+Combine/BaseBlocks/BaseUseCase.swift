//
//  BaseUseCase.swift
//  DesignCombineUIKit
//
//  Created by Duke Nguyen on 2026/04/03.
//
//  Defines use-case contracts for MVVM+Coordinator architecture.
//  The base package provides only abstractions; feature modules provide implementations.
//

import Combine

/// A use-case contract that maps an input to one async output.
///
/// - Important: This module is intentionally contract-only.
///   Put feature/domain business logic implementations outside `DesignCombineUIKit`.
public protocol UseCase<Input, Output> {
    associatedtype Input
    associatedtype Output

    /// Executes the use case with the given input.
    /// - Parameter input: Input for the business intent.
    /// - Returns: A publisher that emits one output or fails with `Error`.
    func execute(_ input: Input) -> AnyPublisher<Output, Error>
}

/// A use-case contract that performs work and only signals completion or failure.
public protocol CompletableUseCase<Input> {
    associatedtype Input

    /// Executes the use case with the given input.
    /// - Parameter input: Input for the business intent.
    /// - Returns: A publisher that emits `Void` on completion or fails with `Error`.
    func execute(_ input: Input) -> AnyPublisher<Void, Error>
}

/// A use-case contract that maps an input to a stream of values.
public protocol StreamUseCase<Input, Element> {
    associatedtype Input
    associatedtype Element

    /// Executes the use case with the given input.
    /// - Parameter input: Input for the business intent.
    /// - Returns: A value stream publisher that may fail with `Error`.
    func execute(_ input: Input) -> AnyPublisher<Element, Error>
}

public extension UseCase where Input == Void {
    /// Executes a no-input use case.
    func execute() -> AnyPublisher<Output, Error> {
        execute(())
    }
}

public extension CompletableUseCase where Input == Void {
    /// Executes a no-input use case.
    func execute() -> AnyPublisher<Void, Error> {
        execute(())
    }
}

public extension StreamUseCase where Input == Void {
    /// Executes a no-input use case.
    func execute() -> AnyPublisher<Element, Error> {
        execute(())
    }
}

/// Backward-compatible aliases that follow existing `*ing` naming style.
public typealias UseCaseing<Input, Output> = UseCase<Input, Output>
public typealias CompletableUseCaseing<Input> = CompletableUseCase<Input>
public typealias StreamUseCaseing<Input, Element> = StreamUseCase<Input, Element>
