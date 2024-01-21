//
//  File.swift
//
//
//  Created by Duc Minh Nguyen on 1/7/24.
//

import SwiftUI
import DesignCore

public extension ErrorOption {
    static let ok: ErrorOption = .init(title: "OK", style: .cancel)
    
    @available(iOS 15.0, macOS 12.0, *)
    var button: some View {
        switch style {
        case .cancel:
            return Button { action?() } label: { Text(title).fontWeight(.semibold) }
        case .default:
            return Button { action?() } label: { Text(title) }
        case .destructive:
            return Button { action?() } label: { Text(title).foregroundColor(Color(.systemRed)) }
        }
    }

    var regularButton: some View {
        switch style {
        case .cancel:
            return Button(role: .cancel) { action?() } label: { Text(title) }
        case .default:
            return Button(role: .none) { action?() } label: { Text(title) }
        case .destructive:
            return Button(role: .destructive) { action?() } label: { Text(title) }
        }
    }
}

public protocol ErrorHandlable {
    func showError(with vm: ViewModeling) -> Binding<Bool>
}

public extension ErrorHandlable {
    func showError(with vm: ViewModeling) -> Binding<Bool> {
        .init { vm.error != nil } set: { _ in vm.error = nil }
    }
}

public extension View {
    @ViewBuilder
    func handle(title: String = "Error", error: Error?, showError: Binding<Bool>, action: [ErrorOption] = [.ok]) -> some View {
        if let error = error as? SelfHandlableError {
            confirmationDialog(error.title, isPresented: showError) {
                ForEach(error.options) { $0.button }
            } message: {
                Text(error.message)
            }
        } else {
            alert(title, isPresented: showError) {
                ForEach(action) { $0.regularButton }
            } message: {
                Text(error?.localizedDescription ?? "Unknown error")
            }
        }
    }
}
