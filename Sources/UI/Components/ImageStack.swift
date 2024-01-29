//
//  ImageStack.swift
//
//
//  Created by Duc IT. Nguyen Minh on 27/01/2024.
//

import SwiftUI
import DesignCore

public struct ImageStack: View, SelfCustomizable {
    public var primary: Model
    public var stack: [Model] = []
    
    public init(primary: Model, stack: [Model] = []) {
        self.primary = primary
        self.stack = stack
    }
    
    public var body: some View {
        ZStack {
            primary.updated(for: \.alignment, with: .center).body()
            ForEach(stack) {
                $0.body(relativeTo: primary.size)
            }
        }
    }
}

public extension ImageStack {
    struct Model: Identifiable, SelfCustomizable {
        public var id = UUID().uuidString
        public var name: String
        public var alignment: Alignment = .bottomTrailing
        public var size: CGSize = .init(width: 24, height: 24)
        public var offset: CGSize = .zero
        public var color: Color?
        public var customizable: ((AnyView) -> AnyView)?
        
        public init(name: String, alignment: Alignment = .bottomTrailing,
             size: CGSize = .init(width: 24, height: 24), offset: CGSize = .zero,
             color: Color? = nil, customizable: ((AnyView) -> AnyView)? = nil) {
            self.name = name
            self.alignment = alignment
            self.size = size
            self.offset = offset
            self.color = color
            self.customizable = customizable
        }
        
        @ViewBuilder
        func body(relativeTo parentSize: CGSize? = nil) -> some View {
            if let customizable {
                customizable(.init(Image(systemName: name).resizable(
                    width: size.width,
                    height: size.height
                )))
                .if(color) {
                    $0.foregroundStyle($1)
                }
                .offset(offset(relativeTo: parentSize ?? .zero))
                .offset(offset)
            } else {
                Image(systemName: name).resizable(
                    width: size.width,
                    height: size.height
                )
                .if(color) {
                    $0.foregroundStyle($1)
                }
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

#Preview {
    VStack {
        ImageStack(
            primary: .init(
                name: "square.and.arrow.down.fill",
                size: .init(width: 60, height: 60),
                color: .red
            ),
            stack: [
                .init(
                    name: "1.circle.fill",
                    color: .blue
                )
            ]
        )
        Spacer().frame(height: 100)
        ImageStack(
            primary: .init(
                name: "square.and.arrow.down.fill",
                size: .init(width: 90, height: 90)
            ),
            stack: [
                .init(
                    name: "1.circle.fill",
                    alignment: .bottomTrailing,
                    size: .init(width: 20, height: 20),
                    color: .red
                ),
                .init(
                    name: "2.circle.fill",
                    alignment: .topLeading,
                    size: .init(width: 30, height: 30),
                    offset: .init(width: 10 , height: 30),
                    color: .green,
                    customizable: { item in
                            .init(
                                item.background(
                                    Color.white.clipShape(Circle())
                                )
                            )
                    }
                ),
                .init(
                    name: "3.circle.fill",
                    alignment: .topTrailing,
                    size: .init(width: 20, height: 20),
                    color: .blue
                )
            ]
        )
    }
}
