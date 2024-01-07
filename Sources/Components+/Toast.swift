//
//  Toast.swift
//  Views
//
//  Created by Duc IT. Nguyen Minh on 29/09/2023.
//

import SwiftUI

public struct Toast: ViewModifier {
    // these correspond to Android values f
    // or DURATION_SHORT and DURATION_LONG
    public static let short: TimeInterval = 2
    public static let long: TimeInterval = 3.5
    
    let message: String
    @Binding var isShowing: Bool
    let config: Config
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            toastView
        }
    }
    
    private var toastView: some View {
        VStack {
            if config.position == .bottom {
                Spacer()
            }
            if isShowing {
                Group {
                    Text(message)
                        .multilineTextAlignment(.center)
                        .foregroundColor(config.textColor)
                        .font(config.font)
                        .padding(8)
                }
                .background(config.backgroundColor)
                .cornerRadius(8)
                .onTapGesture {
                    isShowing = false
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + config.duration) {
                        isShowing = false
                    }
                }
            }
            if config.position == .top {
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(config.position.padding, 16)
        .animation(config.animation, value: isShowing)
        .transition(config.transition)
    }
    
    public struct Config {
        public enum Position {
            case top
            case bottom
            
            var padding: Edge.Set {
                switch self {
                case .top:
                    return .top
                case .bottom:
                    return .bottom
                }
            }
            
            var transition: AnyTransition {
                switch self {
                case .top:
                    return .move(edge: .top)
                case .bottom:
                    return .move(edge: .bottom)
                }
            }
        }
        
        let textColor: Color
        let position: Position
        let font: Font
        let backgroundColor: Color
        let duration: TimeInterval
        let transition: AnyTransition
        let animation: Animation
        
        public init(position: Position = .top,
             textColor: Color = .white,
             font: Font = .system(size: 14),
             backgroundColor: Color = .black.opacity(0.588),
             duration: TimeInterval = Toast.short,
             transition: AnyTransition? = nil,
             animation: Animation = .linear(duration: 0.3)) {
            self.position = position
            self.textColor = textColor
            self.font = font
            self.backgroundColor = backgroundColor
            self.duration = duration
            self.transition = transition ?? position.transition
            self.animation = animation
        }
    }
}

public extension View {
    func toast(message: String,
               isShowing: Binding<Bool>,
               config: Toast.Config) -> some View {
        modifier(Toast(
            message: message,
            isShowing: isShowing,
            config: config
        ))
    }
    
    func toast(message: String,
               isShowing: Binding<Bool>,
               duration: TimeInterval) -> some View {
        modifier(Toast(
            message: message,
            isShowing: isShowing,
            config: .init(duration: duration)
        ))
    }
}

#if DEBUG
struct TestView: View {
    @State var toasting: Bool = false
    
    var body: some View {
        VStack {
            Button("Start toasting...") {
                toasting = true
                print("Toasting")
            }
        }.toast(
            message: "Copied from clipboard",
            isShowing: $toasting,
            duration: 2
        )
    }
}

#Preview {
    NavigationView {
        TestView()
    }
}
#endif
