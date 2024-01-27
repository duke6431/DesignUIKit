//
//  ImageStack.swift
//
//
//  Created by Duc IT. Nguyen Minh on 27/01/2024.
//

import SwiftUI
import DesignCore

struct ImageStack: View, SelfCustomizable {
    var primary: Model
    var stack: [Model] = []
    
    var body: some View {
        ZStack {
            primary.updated(for: \.alignment, with: .center).body()
            ForEach(stack) {
                $0.body(relativeTo: primary.size)
            }
        }
    }
}

extension ImageStack {
    struct Model: Identifiable, SelfCustomizable {
        var id = UUID().uuidString
        var name: String
        var alignment: Alignment = .bottomTrailing
        var size: CGSize = .init(width: 24, height: 24)
        var offset: CGSize = .zero
        var color: Color = .black
        var customizable: ((AnyView) -> AnyView)?
        
        @ViewBuilder
        func body(relativeTo parentSize: CGSize? = nil) -> some View {
            if let customizable {
                customizable(.init(Image(systemName: name).resizable(
                    width: size.width,
                    height: size.height
                )))
                .foregroundColor(color)
                .offset(offset(relativeTo: parentSize ?? .zero))
                .offset(offset)
            } else {
                Image(systemName: name).resizable(
                    width: size.width,
                    height: size.height
                )
                .foregroundColor(color)
                .offset(offset(relativeTo: parentSize ?? .zero))
                .offset(offset)
            }
        }
        
        func offset(relativeTo size: CGSize) -> CGSize {
            let halfSize: CGSize = size / 2
            switch alignment {
            case .topLeading:
                return .init(width: -halfSize.width, height: -halfSize.height)
            case .top:
                return .init(width: 0, height: -halfSize.height)
            case .topTrailing:
                return .init(width: halfSize.width, height: -halfSize.height)
            case .leading:
                return .init(width: -halfSize.width, height: 0)
            case .trailing:
                return .init(width: halfSize.width, height: 0)
            case .bottomLeading:
                return .init(width: -halfSize.width, height: halfSize.height)
            case .bottom:
                return .init(width: 0, height: halfSize.height)
            case .bottomTrailing:
                return .init(width: halfSize.width, height: halfSize.height)
            default:
                // All point to center
                return .zero
            }
        }
    }
}

extension CGSize {
    static func + (lhs: CGSize, rhs: CGSize?) -> CGSize {
        .init(width: lhs.width + (rhs?.width ?? 0), height: lhs.height + (rhs?.height ?? 0))
    }
    
    static func / (lhs: CGSize, rhs: CGFloat) -> CGSize {
        .init(width: lhs.width / rhs, height: lhs.height / rhs)
    }
}
